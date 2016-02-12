module DeviseMailerUrlHelper
  def multitenant_domain
    protocol = Rails.application.config.default_email_link_protocol
    if tenant = Tenant.where(database_name: Apartment::Tenant.current_tenant).first
      "#{protocol}://#{tenant.domain}"
    else
      "#{protocol}://#{ENV['EMAIL_DOMAIN']}"
    end
  end
end
