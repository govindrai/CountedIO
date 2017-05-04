class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  include LinkHelper

  def show
    if @user.authorized?(params[:random])
      puts "DATE PARAMS"
      p params[:date]
      @date = params[:date] ? DateTime.parse(params[:date]) : DateTime.now
      p @date
      @meals = @user.get_all_meals(@date)

      if request.xhr?
        if params[:direction] == 'forward'
          @date+= 1
        else
          @date-= 1
        end
        data = {data: @user.get_pie_chart_data(@date), date: @date.strftime("%F")}.to_json
        render json: data, layout:false
      else
        @chart_data = @user.get_pie_chart_data(@date)
      end
    else
      puts "USER NOT AUTHORIEZED"
    end
  end

  def month

  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
