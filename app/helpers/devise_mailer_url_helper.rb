module DeviseMailerUrlHelper
  def multitenant_domain
    protocol = Rails.application.config.default_email_link_protocol
    tenant = Tenant.current_tenant
    if tenant
      "#{protocol}://#{tenant.domain}"
    else
      "#{protocol}://#{ENV['EMAIL_DOMAIN']}"
    end
  end
end
