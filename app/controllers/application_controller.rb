class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_domain_config

  def after_sign_in_path_for(user)
      @now = DateTime.current().to_time.iso8601
      session['jwt'] = JWT.encode(
          {
              'consumerKey' => ENV["API_CONSUMER"],
              'userId' => user.email,
              'issuedAt' => @now,
              'ttl' => 86400
          },
          ENV["API_SECRET"]
      )
      user_url(user)
  end

  def authenticate
    redirect_to root_path, notice: "You need to be signed in" unless user_signed_in?
  end

  # Copied from Miximize!
  # https://github.com/ryanb/cancan/wiki/Exception-Handling
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render action: 404, status: :not_found
  end

  def current_tenant
    Apartment::Database.current_tenant
  end

  def set_domain_config
    $DOMAIN_CONFIG = DOMAIN_CONFIGS['public']
    if (request.subdomain.present? && DOMAIN_CONFIGS[request.subdomain].present?)
      $DOMAIN_CONFIG = DOMAIN_CONFIGS[request.subdomain]
    else
      $DOMAIN_CONFIG = DOMAIN_CONFIGS['default']
    end
  end
end
