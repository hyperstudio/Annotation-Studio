class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  # add_breadcrumb :index, :root_path
  
  def signed_in?
    @now = DateTime.current().to_time.iso8601
    @jwt = JWT.encode(
        {
            'consumerKey' => ENV["API_CONSUMER"],
            'userId' => current_user.email,
            'issuedAt' => @now,
            'ttl' => 86400
        }, 
        ENV["API_SECRET"]
    )
    gon.current_user = current_user
  end
  helper_method :signed_in?

  def authenticate
    redirect_to root_path, notice: "You need to be signed in" unless signed_in?
  end

  # Copied from Miximize!
  # https://github.com/ryanb/cancan/wiki/Exception-Handling
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
end