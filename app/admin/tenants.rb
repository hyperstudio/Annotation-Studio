ActiveAdmin.register Tenant do
  permit_params :domain, :database_name

  form do |f|
    f.inputs "Tenant Details" do
      f.input :domain, :as => :string, label: 'The domain, ex - "app.example.com":'
      f.input :database_name, :as => :string, label: 'The internal database name, ex - "app":'
    end
    f.actions do
      f.action :submit
      f.action :cancel, :wrapper_html => { :class => "cancel" }
    end
  end
end
