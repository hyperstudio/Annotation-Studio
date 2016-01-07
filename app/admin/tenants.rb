ActiveAdmin.register Tenant do
  form do |f|
    f.inputs "Tenant Details" do
      f.input :domain, :as => :string, label: 'The domain, ex - "app.example.com":'
      f.input :mel_catalog_enabled, :as => :boolean, label: 'Enables MEL Catalog features'
      f.input :mel_catalog_url, :as => :string, label: 'The full url, ex - "https://mel-catalog-staging.herokuapp.com"'
      f.input :annotation_categories_enabled, :as => :boolean, label: 'Enables Annotation Categories'
      f.input :database_name, :as => :string, label: 'The internal database name, ex - "app":'
    end
    f.buttons
  end
end
