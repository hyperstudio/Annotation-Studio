ActiveAdmin.register Document do
  
  scope :all, :default => true
  actions :all, :except => [:edit, :new]

  filter :title
  filter :author
  filter :publication_date
  filter :created_at
  filter :updated_at
  filter :groups, label: 'Group', collection: proc { Group.order(:name) }

  index do |t|
    selectable_column
    id_column
    column "Title", :title
    column "Source", :source
    column "Groups", :groups, :sortable => false
    column "Creation date", :created_at
    actions
  end

  show do |document|
    attributes_table do
      row :title
      row :groups
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
