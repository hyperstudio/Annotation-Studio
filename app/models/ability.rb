class Ability
  include CanCan::Ability
  include Repertoire::Groups::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # If CanCan doesn't find a match for the above, it falls through 
    # to the default abilities provided by Repertoire Groups:
    defaults_for user

    if user.has_role? :admin
      can :manage, :all

    elsif user.has_role? :teacher
      can :create, Document
      can :manage, Document do |tors|
        tors.user.id == user.id
      end

    elsif user.has_role? :student
      # Why not?
      cannot :manage, Document
      # can :create, Document

      # can :manage, Document do |tors|
      #   tors.user.id == user.id
      # end

      can :read, Document do |tors|
        !(user.rep_group_list & tors.rep_group_list).empty?
      end

      # cannot :read, [Document] do |tors|
      #   tors.rep_privacy_list.detect {|t| t == 'review'}
      # end
    else
      cannot :manage, :all
      can :read, [Document] do |tors|
        tors.rep_privacy_list.detect {|t| t == 'public'}
      end
    end
    can :index, Document
  end
end
