class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  include LinkHelper

  def show
    if @user.randomized_profile_url == params[:random]
      @authorized = true
    end

    if params[:week]
      @date =  ''
    elsif params[:month]
      @date = ''
    else
      @date = DateTime.parse(params[:date])
    end
    @meals = Meal.where(user: @user)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
