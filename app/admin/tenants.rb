ActiveAdmin.register Tenant do
  permit_params :domain, :database_name

  form do |f|
    f.inputs "Tenant Details" do
      f.input :domain, :as => :string, label: 'The domain, ex - "app.example.com":'
      f.input :mel_catalog_enabled, :as => :boolean, label: 'Enables MEL Catalog features'
      f.input :mel_catalog_url, :as => :string, label: 'The full url, ex - "http://mel-catalog.herokuapp.com/api/"'
      f.input :annotation_categories_enabled, :as => :boolean, label: 'Enables Annotation Categories'
      f.input :database_name, :as => :string, label: 'The internal database name, ex - "app":'
    end
    f.actions do
      f.action :submit
      f.action :cancel, :wrapper_html => { :class => "cancel" }
    end
  end
end
