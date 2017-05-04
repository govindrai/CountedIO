class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  include LinkHelper

  def show
    @authorized = true if @user.randomized_profile_url == params[:random]

    if params[:week]
      dates = params[:week].split('_')
      @range = (DateTime.parse(dates[0])..DateTime.parse(dates[1]))
      @date =  DateTime.parse(dates[0])
    elsif params[:month]
      @date = DateTime.new(DateTime.now.year, params[:month])
    else
      @date = params[:date] ? DateTime.parse(params[:date]) : DateTime.now
      @meals = Meal.get_day_meals(@user, @date)
      @chart_data = Meal.get_pie_chart_data(@user, @date)
    end


    if request.xhr?
      if params[:direction] == 'forward'
        @date = DateTime.parse(params[:date]) + 1
      else
        @date = DateTime.parse(params[:date]) - 1
      end
      p @date
      @chart_data = {data: Meal.get_pie_chart_data(@user, @date), date: @date.strftime("%F")}.to_json
      render json: @chart_data, layout:false
    else
      @chart_data = Meal.get_pie_chart_data(@user, @date)
    end
  end

  def month

  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
