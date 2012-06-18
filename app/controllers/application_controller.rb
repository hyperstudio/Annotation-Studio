class ApplicationController < ActionController::Base
  protect_from_forgery

  def signed_in?
    @jwt = JWT.encode(
        {
            'consumerKey' => "CONSUMER_KEY",
            'userId' => "jfolsom",
            'issuedAt' => "2012-06-14",
            'ttl' => 86400
        }, 
        "secretgoeshere"
      )
  end
  helper_method :signed_in?

  def authenticate
    redirect_to root_path, notice:"You need to be signed in" unless signed_in?
  end

end
