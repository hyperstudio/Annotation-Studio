require 'apartment/elevators/generic'

Apartment.configure do |config|

  # These models will not be multi-tenanted,
  # but remain in the global (public) namespace
  #
  config.excluded_models = %w{Tenant AdminUser Delayed::Backend::ActiveRecord::Job}

  config.use_schemas = true

  # configure persistent schemas (E.g. hstore )
  # config.persistent_schemas = %w{ hstore }

  # supply list of database names for migrations to run on
  config.tenant_names = lambda{ Tenant.pluck :database_name }
end

Rails.application.config.middleware.use 'Apartment::Elevators::Generic', lambda { |request|
  domain = request.host
  if tenant = Tenant.where(domain: domain).first
    tenant.database_name
  else
    'public'
  end
}

Rails.application.config.default_email_link_protocol = (ENV['DEFAULT_EMAIL_LINK_PROTOCOL'] || 'https')
