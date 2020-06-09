ActiveAdmin.register Document do
  
  scope :all, :default => true
  actions :all, :except => [:edit, :new]

  filter :title
  filter :author
  filter :publication_date
  filter :created_at
  filter :updated_at
  filter :state
  filter :groups, label: 'Group', collection: proc { Group.order(:name) }

  index do |t|
    selectable_column
    id_column
    column "Title", :title
    column "Groups", :groups, :sortable => false
    column "Creation date", :created_at
    column "State", :state
    actions
  end

  show do |document|
    attributes_table do
      row :resource_type
      row :title
      row :author
      row :publication_date
      row :edition
      row :publisher
      row :source
      row :rights_status
      row :page_numbers
      row :series
      row :location
      row :journal_title
      row :notes
      row('User') { |d| link_to d.user.fullname.to_s, admin_user_path(d.user.id) }
      row :groups
      row :state
      row :created_at
      row :updated_at
    end
  end

  controller do
    def find_resource
      Document.friendly.find(params[:id])
    end
    def permitted_params
      params.permit!
    end
  end
end
