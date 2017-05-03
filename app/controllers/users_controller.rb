class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  include LinkHelper

  def show
    if @user.randomized_profile_url == params[:random]
      @authorized = true
    end

    if request.xhr?
      @chart_data = {data: Meal.get_pie_chart_data(@user, @date)}.to_json
      head :ok
    else
      if params[:week]
        dates = params[:week].split('_')
        @range = (DateTime.parse(dates[0])..DateTime.parse(dates[1]))
        @date =  DateTime.parse(dates[0])
      elsif params[:month]
        @date = DateTime.new(DateTime.now.year, params[:month])
      else
        @date = DateTime.parse(params[:date])
      end
        @chart_data = Meal.get_pie_chart_data(@user, @date)
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
