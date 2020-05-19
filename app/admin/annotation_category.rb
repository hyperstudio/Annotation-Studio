ActiveAdmin.register AnnotationCategory do
  permit_params :name, :hex, :css_classes

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
    actions
  end

  show do |document|
    attributes_table do
      row :name
      row :hex
      row :css_classes
    end
  end
end
