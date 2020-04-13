module Api::V1
  class CredentialsController < ApiController
    before_action :doorkeeper_authorize!
    respond_to    :json, :html

    def me
      respond_with current_resource_owner
    end

    def my_groups
      @user = current_resource_owner
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
    end
  end
end
