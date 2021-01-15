ActiveAdmin.register Group do
  scope :all, :default => true
  actions :all, :except => [:new]

  filter :name, label: "Group Name"
  filter :owner_id, as: :numeric, label: 'Owner ID number (can find users\' ID numbers in Users tab)'

  
  permit_params do
    permitted = [:name]
  end

  index do |t|
    selectable_column
    id_column
    column "Name", :name
    column "Owner" do |group|
      u = User.find_by_id(group.owner_id)
      u.fullname
    end
    column "Creation date", :created_at
    actions
  end

  member_action :manage, method: :get do
    user = User.find_by(email: current_admin_user.email)
    if !user 
      flash[:alert] = "User not found. Is the admin user's email the same as the user's email?"
    elsif (!user.groups.include? resource)
      resource.users << user
      if resource.save
        Membership.find_by(group_id: resource.id, user_id: user.id).update_attribute("role", "manager")
        flash[:notice] = user.fullname + " added as manager."
      end
    elsif (Membership.find_by(group_id: resource.id, user_id: user.id).role != 'member')
      flash[:alert] = "User already owner or manager of group."
    else 
      Membership.find_by(group_id: resource.id, user_id: user.id).update_attribute("role", "manager")
      flash[:notice] = user.fullname + " added as manager."
    end
    redirect_to admin_group_path(resource)
  end

  action_item :manage,
              priority: 0,
              only: :show,
              if: proc{ 
                  @u = User.find_by(email: current_admin_user.email)
                  @m = Membership.find_by(group_id: resource.id, user_id: @u.id)
                  @m.nil? || @m.role == 'member'
                } do
    link_to 'Manage', manage_admin_group_path
  end
  
  show do |group|
    attributes_table do
      row :name
      row :owner do 
        u = User.find_by_id(group.owner_id)
        link_to (u.fullname + " (" + u.email + ")"), admin_user_path(u.id)
      end
      row :managers do
        list = ''
        group.memberships.each do |m|
          if m.role == 'manager'
            u = User.find_by_id(m.user_id)
            list += link_to u.fullname, admin_user_path(u.id) 
            list += ', '
          end
        end
        list[0..-3].html_safe
      end
      row :members do
        list = ''
        group.memberships.each do |m|
          u = User.find_by_id(m.user_id)
          list += link_to u.fullname, admin_user_path(u.id) 
          list += ' ('+ m.role + '), '
        end
        list[0..-3].html_safe
      end
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :name, :as => :string
    end
    f.actions do
      f.action :submit
      f.action :cancel, :wrapper_html => { :class => "cancel" }
    end
  end

end
