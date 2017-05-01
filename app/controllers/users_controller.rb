class UsersController < ApplicationController
  before_action do |controller|
    @user = User.find(params[:user_id])
  end

  def show
    if @user.randomized_profile_url == params[:random]
      puts "You are authorized"
    end
  end

end
