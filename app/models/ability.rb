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
      can :publicize, Document, { :user_id => user.id }

    elsif user.has_role? :teacher
      cannot :manage, Document do |tors|
        if tors.user.nil?  # This has been driving me insane.
          false
        else
          tors.user.id == user.id
        end
      end
      can :create, Document
      can [:read, :update, :publish, :archive, :preview, :export, :set_default_state, :snapshot], Document, { :user_id => user.id }
      can :destroy, Document, { :user_id => user.id, :published? => false }

    elsif user.has_role? :student
      cannot :manage, Document
      can :create, Document
      can [:read, :update, :publish, :archive], Document, { :user_id => user.id }
      can :destroy, Document, { :user_id => user.id, :published? => false }
      can :read, Document do |tors|
        !(user.rep_group_list & tors.rep_group_list).empty?
      end

    else
      cannot :manage, :all
      can :read, Document, { :public? => true }
    end

    can :index, Document
  end
end
