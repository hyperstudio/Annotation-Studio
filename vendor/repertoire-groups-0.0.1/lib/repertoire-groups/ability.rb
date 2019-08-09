module Repertoire
  module Groups
    module Ability

      #
      # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
      #
      # This method is meant to be called by the Ability class defined in an 
      # Application.  This is because while these authorizations are commonly used 
      # in most HyperStudio Repertoire apps, this may not always be the case.
      #
      # Note that this also assumes a tag_list (used by acts_as_taggable_on)
      # with the name of 'rep_privacy_list'; by default Groups are defined very simply
      # in Repertoire using acts_as_taggable_on tag_lists.
      #
      # By not calling this method in your Ability class, this frees you up to use 
      # only the default Role methodology provided by Repertoire::Groups, or some 
      # other Group architecture.
      #

      def defaults_for(user)
        user ||= User.new # guest user (not logged in)

        if user.has_role? :admin
          can :manage, :all
        else
          # "The ability rules further down in a file will override a previous one."
          # https://github.com/ryanb/cancan/wiki/Ability-Precedence

          # Okay, this pretty much closes everything down.
          # Override this in your application's Ability class to allow...any functionality.
          cannot :manage, :all

          # If a User is in the same group as the Model, the User can read it.
          can :read, :all do |tors|
            !(user.rep_group_list & tors.rep_group_list).empty?
          end

          # If an Object is set to be private, we prevent anyone from doing anything...
          cannot :manage, :all do |tors|
            tors.rep_privacy_list.detect {|t| t == 'private'}
          end

          # Otherwise, no one can destroy any other User's Objects
          cannot :destroy, :all

          # Okay, seems like something happens when you test on the Class--
          # for example, without the 'unapproved' condition, a new User can
          # successfully pass the 'if can? :create, StringAnnotation' test.
          # I don't see why that should be, but there it is.

          unless user.has_role? :unapproved
            # The User that owns the Object can do anything they want.
            can :manage, :all do |tors|
              if tors.user.nil?  # This has been driving me insane.
                false
              else
                tors.user.id == user.id
              end
            end
          end

          # If a Model is set as public, all Users can read it.
          can :read, :all do |tors|
            tors.rep_privacy_list.detect {|t| t == 'public'}
          end

          cannot :manage, UserSet
        end
      end
    end
  end
end
