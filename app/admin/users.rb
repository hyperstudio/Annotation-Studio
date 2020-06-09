ActiveAdmin.register User, :as => "User" do
  permit_params :firstname, :lastname, :affiliation, :email, :groups

  scope :all, :default => true

  filter :firstname
  filter :lastname
  filter :email
  filter :affiliation
  filter :created_at
  filter :updated_at
  filter :last_sign_in_at
  filter :groups, label: 'Group', collection: proc { Group.order(:name) }

  batch_action :approve do |selection|
    User.find(selection).each do |user|
      user.set_roles = ['student']
    end
    redirect_to collection_path, :notice => "Users approved!"
  end
    
  index do |t|
    selectable_column
    id_column
    column "First name", :firstname
    column "Last name", :lastname
    column :affiliation
    column "Groups", :groups, :sortable => false
    column "Creation date", :created_at
    actions
  end

  show do |user|
    attributes_table do
      row :fullname
      row :affiliation
      row :email
      row :groups do 
        list = ''
        user.memberships.each do |m|
          list += link_to Group.find_by_id(m.group_id).name, admin_group_path(m.group_id)
          list += " (" + m.role.to_s + "), "
        end
        list[0..-3].html_safe
      end
      row :documents do
        user.documents.sort_by {|d| d.title}
      end
      row("Joined") { |u| u.created_at }
      row :updated_at
      row :current_sign_in_at
      row :last_sign_in_at
      row :annotations do 
        render 'show_annotations', { user: user }
      end
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :firstname, :as => :string
      f.input :lastname, :as => :string
      f.input :affiliation, :as => :string
      f.input :email, :as => :string
    end
    f.actions do
      f.action :submit
      f.action :cancel, :wrapper_html => { :class => "cancel" }
    end
  end

  controller do
    def find_resource
      User.friendly.find(params[:id])
    end
    def permitted_params
      params.permit!
    end
  end
end
