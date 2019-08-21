class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def index
    @users = User.where.not(id: current_resource_owner)
    render json: @users
  end

  def me
    @user = current_resource_owner
    render json: @user
  end
end