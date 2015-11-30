ActiveAdmin.register User, :as => "Student" do

  scope :all, :default => true

  filter :firstname
  filter :lastname
  filter :affiliation
  filter :created_at
  filter :updated_at
  filter :last_sign_in_at
  filter :taggings_tag_name, label: 'Class and Group Names', :as => :check_boxes, :collection => proc { User.rep_group_counts.map{|t| t.name} }

  batch_action :approve do |selection|
    User.find(selection).each do |user|
      user.set_roles = ['student']
      redirect_to collection_path, :notice => "Users approved!"
    end
  end

  batch_action :make_admin do |selection|
    User.find(selection).each do |user|
      user.set_roles = ['admin']
      redirect_to collection_path, :notice => "Admins created!"
    end
  end
    
  index do |t|
    selectable_column
    id_column
    column "First name", :firstname
    column "Last name", :lastname
    column :affiliation
    column "Groups", :rep_group_list, :sortable => false
    column "Creation date", :created_at
    default_actions
  end

  show do |user|
    attributes_table do
      row :fullname
      row :rep_group_list
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Details" do
      f.input :firstname, :as => :string
      f.input :lastname, :as => :string
      f.input :affiliation, :as => :string
      f.input :email, :as => :string
      f.input :rep_group_list, 
      :label => "Add/remove existing groups",
        # :input_html => { :size => 50 },
        :as => :check_boxes,
        # :multiple => :true,
        :collection => ActsAsTaggableOn::Tag.all.map(&:name)
      # f.input :rep_group_list, 
      #   :value => nil,
      #   :placeholder_text => "Type new group here",
      #   :as => :string,
      #   :label => "Create (and add user to) a new group"
    end
    f.buttons
  end
end
