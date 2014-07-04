class UsersController < ApplicationController
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

  def show
    if params[:id].nil? # if there is no user id in params, show current one
      @user = current_user
    else
      @user = User.find params[:id]
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end

    gon.rabl template: 'app/views/users/show.rabl', as: 'user'
  end

  def edit
    @user = User.find(params[:id])
  end
end
