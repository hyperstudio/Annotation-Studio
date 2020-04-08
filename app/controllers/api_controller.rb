class ApiController < ApplicationController	
  respond_to    :json

  # GET /me.json
  def me
    # If logged in
    if !current_user.nil?
      @user = current_user
      my_groups = []
      @user.group_ids.each do |g|
        my_groups << {id: g, name: Group.where(id: g).first.name}
      end
      respond_to do |format|
        format.json do
          render json: {
            email: @user.email,
            groups: my_groups
          }.to_json
        end
      end    
    
    # If not logged in
    else
      respond_to do |format|
        format.json do
          render json: {
           "error": {
            "code": 401,
            "message": "Login Required"
            }}.to_json
        end
      end
    end
  end
end
