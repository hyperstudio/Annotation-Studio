ActiveAdmin.register AnnotationCategory do
  scope :all, :default => true

  filter :name
  filter :hex
  filter :css_classes

  index do |t|
    selectable_column
    id_column
    column "Name", :name
    column "Hex", :hex
    column "CSS Classes", :css_classes
    default_actions
  end

  show do |document|
    attributes_table do
      row :name
      row :hex
      row :css_classes
    end
    active_admin_comments
  end
end
