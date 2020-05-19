ActiveAdmin.register User, :as => "Student" do
  permit_params :firstname, :lastname, :affiliation, :email, :groups

  scope :all, :default => true

  filter :firstname
  filter :lastname
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
      row :email
      row :groups
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
