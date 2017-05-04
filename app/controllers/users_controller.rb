class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  include LinkHelper

  def show
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
