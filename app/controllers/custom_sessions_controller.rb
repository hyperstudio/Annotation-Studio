class CustomSessionsController < Devise::SessionsController
  after_action :after_login, :only => :create

  def after_login
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
  end
end
