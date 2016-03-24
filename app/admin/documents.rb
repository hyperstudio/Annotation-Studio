ActiveAdmin.register Document do
  scope :all, :default => true

  # scope :due_this_week do |documents|
  #   documents.where('due_date > ? and due_date < ?', Time.now, 1.week.from_now)
  # end

  # scope :mine do |documents|
  #   documents.where(:user_id => current_user.id)
  # end
      
  filter :title
  filter :author
  filter :publication_date
  filter :created_at
  filter :updated_at
  filter :taggings_tag_name, label: 'Class and Group Names', :as => :check_boxes, :collection => proc { Document.rep_group_counts.map{|t| t.name.downcase}.sort! }

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
    actions
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
        :label => "Share this document with a class",
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
      Document.friendly.find(params[:id])
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
