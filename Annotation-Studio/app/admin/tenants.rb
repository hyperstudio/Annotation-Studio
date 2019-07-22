ActiveAdmin.register Tenant do
  permit_params :domain, :database_name, :annotation_categories_enabled

  form do |f|
    f.inputs "Tenant Details" do
      f.input :domain, :as => :string, label: 'The domain, ex - "app.example.com":'
      f.input :annotation_categories_enabled, :as => :boolean, label: 'Enables Annotation Categories'
      f.input :database_name, :as => :string, label: 'The internal database name, ex - "app":'
    end
    f.actions do
      f.action :submit
      f.action :cancel, :wrapper_html => { :class => "cancel" }
    end
  end
end
