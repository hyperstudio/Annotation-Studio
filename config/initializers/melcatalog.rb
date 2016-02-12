if ActiveRecord::Base.connection.table_exists? 'tenants'
  tenant = Tenant.current_tenant

  if tenant && tenant.mel_catalog_enabled 
    Melcatalog.configure do |config|
      config.service_endpoint = tenant.mel_catalog_url
    end
  end
end