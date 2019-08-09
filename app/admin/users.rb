ActiveAdmin.register User, :as => "Student" do
  permit_params :firstname, :lastname, :affiliation, :email, :rep_group_list

  scope :all, :default => true

  filter :firstname
  filter :lastname
  filter :affiliation
  filter :created_at
  filter :updated_at
  filter :last_sign_in_at
  filter :taggings_tag_name, label: 'Class and Group Names', :as => :check_boxes, :collection => proc { User.all_tags() }

  batch_action :approve do |selection|
    User.find(selection).each do |user|
      user.set_roles = ['student']
    end
    redirect_to collection_path, :notice => "Users approved!"
  end

  batch_action :make_admin do |selection|
    User.find(selection).each do |user|
      user.set_roles = ['admin']
    end
    redirect_to collection_path, :notice => "Admins created!"
  end
    
  index do |t|
    selectable_column
    id_column
    column "First name", :firstname
    column "Last name", :lastname
    column :affiliation
    column "Groups", :rep_group_list, :sortable => false
    column "Creation date", :created_at
    actions
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
        :label => "Add this student to a class",
        input_html: {
        multiple: true,
        data: {
          placeholder: "Start typing to see existing classes or add new ones",
          saved: f.object.rep_group.collect{|t| { :id => t.name, :name => t.name }}.to_json,
          url: autocomplete_tags_path 
        },
        value: f.object.rep_group_list.join(', '),
        class: 'tagselect'
      }

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
    def autocomplete_tags
      @tags = ActsAsTaggableOn::Tag.
        where("name LIKE ?", "#{params[:q]}%").
        order(:name)
      respond_to do |format|
        format.json { render :json => @tags.collect{|t| {:id => t.name, :name => t.name }}}
      end
    end
  end
end
