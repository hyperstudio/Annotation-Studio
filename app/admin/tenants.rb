ActiveAdmin.register Tenant do
  form do |f|
    f.inputs "Tenant Details" do
      f.input :domain, :as => :string, label: 'The domain, ex - "app.example.com":'
      f.input :database_name, :as => :string, label: 'The internal database name, ex - "app":'
    end
    f.buttons
  end
end
