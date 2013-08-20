class UsersController < ApplicationController
  respond_to :json

  def show
    @user = User.find_by_name(params[:id])
    respond_with(@user)
  end
end
