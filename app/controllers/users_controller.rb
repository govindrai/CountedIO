class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    if @user.randomized_profile_url == params[:random]
      @authorized = true
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
