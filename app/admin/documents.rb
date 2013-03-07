ActiveAdmin.register Document do
  scope :all, :default => true
    
  filter :title
  filter :publisher
  filter :publication_date
  filter :created_at
  filter :updated_at
  filter :taggings_tag_name, :as => :check_boxes, :collection => proc { Document.rep_group_counts.map{|t| t.name} }

  # batch_action :approve do |selection|
  #   User.find(selection).each do |user|
  #     user.set_roles = ['student']
  #     redirect_to collection_path, :notice => "Users approved!"
  #   end
  # end
  # 
  # batch_action :make_admin do |selection|
  #   User.find(selection).each do |user|
  #     user.set_roles = ['admin']
  #     redirect_to collection_path, :notice => "Admins created!"
  #   end
  # end
    
  index do |t|
    selectable_column
    id_column
    column "Title", :title
    column "Source", :source  
    column "Groups", :rep_group_list, :sortable => false
    column "Creation date", :created_at
    default_actions
  end

  show do |document|
    attributes_table do
      row :title
      row :rep_group_list
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Details" do
      f.input :title, :as => :string
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
