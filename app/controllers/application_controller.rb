class ApplicationController < ActionController::Base
  protect_from_forgery

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
end
