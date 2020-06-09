ActiveAdmin.register Group do
  scope :all, :default => true
  actions :all, :except => [:new]

  filter :name, label: "Group Name"
  filter :owner_id, as: :numeric, label: 'Owner ID number (can find users\' ID numbers in Users tab)'

  
  permit_params do
    permitted = [:name, :ideaSpaceOn]
  end

  index do |t|
    selectable_column
    id_column
    column "Name", :name
    column "Owner" do |group|
      u = User.find_by_id(group.owner_id)
      u.fullname
    end
    column "Idea Space On", :ideaSpaceOn
    column "Creation date", :created_at
    actions
  end
  
  show do |group|
    attributes_table do
      row :name
      row :owner do 
        u = User.find_by_id(group.owner_id)
        link_to (u.fullname + " (" + u.email + ")"), admin_user_path(u.id)
      end
      row :ideaSpaceOn
      row :members do
        list = ''
        group.memberships.each do |m|
          u = User.find_by_id(m.user_id)
          list += link_to u.fullname, admin_user_path(u.id) 
          list += ' ('+ m.role + '), '
        end
        list[0..-3].html_safe
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
    end
  end


  form do |f|
    f.inputs "Details" do
      f.input :name, :as => :string
      f.input :ideaSpaceOn, :label => "Enable Idea Space"
    end
    f.actions do
      f.action :submit
      f.action :cancel, :wrapper_html => { :class => "cancel" }
    end
  end

end
