ActiveAdmin.register User, :as => "Student" do

  scope :all, :default => true

  filter :firstname
  filter :lastname
  filter :affiliation
  filter :created_at
  filter :updated_at
  filter :taggings_tag_name, :as => :check_boxes, :collection => proc { User.rep_group_counts.map{|t| t.name} }

  index do
    column :id
    column :fullname
    column :affiliation
    column "Groups", :rep_group_list
    column :created_at
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
      f.input :rep_group_list, :label => "Groups",
                         :as => :select,
                         :multiple => :true,
                         :collection => ActsAsTaggableOn::Tag.all.map(&:name)
    end
    f.buttons
  end
end
