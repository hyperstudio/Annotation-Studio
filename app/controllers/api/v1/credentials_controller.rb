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

    def group_members
      my_group_ids = current_resource_owner.group_ids
      if !params[:id]
        respond_to do |format|
          format.json do
            render json: {error: 'The request is missing a required parameter.'}
          end
        end  
      elsif !params[:id].to_i.in?(my_group_ids)
        respond_to do |format|
          format.json do
            render json: {error: 'The authenticated user is not in group with id = ' + params[:id].to_s}
          end
        end  
      else
        group = Group.where(id: params[:id].to_i).first
        memberships = group.memberships
        members = []
        memberships.includes(:user).each do |m|
          members << m.user
        end
        respond_to do |format|
          format.json do
            render json: { members: members }.to_json
          end
        end  
      end
    end
  end
end
