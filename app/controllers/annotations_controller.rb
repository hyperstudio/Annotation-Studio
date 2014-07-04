class AnnotationsController < ApplicationController
  before_filter :authenticate_user!

  before_filter :generate_token
  # add_breadcrumb :index, :root_path

  def generate_token
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
  # helper_method :signed_in?

  def index
  end

  def show
  end
end
