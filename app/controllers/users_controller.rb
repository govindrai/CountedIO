class UsersController < ApplicationController
  before_action :set_user

  def show
    render plain: "USER NOT AUTHORIZED" unless @user.authorized?(params[:random])
  end

  def get_data
    render json: @user.get_data(params[:date], params[:range], params[:direction]), layout:false if request.xhr?
  end

  def get_day_meals
    if request.xhr?
      if params[:date] == "Today"
        @date = DateTime.now
      else
        @date = params[:date] ? DateTime.parse(params[:date]) : DateTime.now
      end

      if params[:direction]
        if params[:direction].include?('forward')
          @date += 1
        elsif params[:direction].include?('back')
          @date -= 1
        end
      end
      @meals = @user.get_all_meals(@date)
      render partial: 'get_day_meals', layout: false, locals: { meals: @meals}
    end
  end


  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
