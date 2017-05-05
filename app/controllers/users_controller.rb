class UsersController < ApplicationController
  before_action :set_user
  include LinkHelper

  def show
    if @user.authorized?(params[:random])
      @date = params[:date] ? DateTime.parse(params[:date]) : DateTime.now
      @chart_data = @user.get_pie_chart_data(@date)
    else
      render plain: "USER NOT AUTHORIZED"
    end
  end

  def get_day_data
    if request.xhr?
      date = params[:date] ? DateTime.parse(params[:date]) : DateTime.now
      range = params[:range]
      direction = params[:direction]
      render json: @user.get_data(date, range, direction), layout:false
    end
  end

  def get_week_data
    if request.xhr?
      date = params[:date] ? DateTime.parse(params[:date]) : DateTime.now
      range = params[:range]
      direction = params[:direction]
      render json: @user.get_data(date, range, direction), layout:false
    end
  end

  def get_month_data
    if request.xhr?
      date = params[:date] ? DateTime.parse(params[:date]) : DateTime.now.beginning_of_month
      range = params[:range]
      direction = params[:direction]
      render json: @user.get_data(date, range, direction), layout:false
    end
  end

  def get_day_meals
    if request.xhr?
      @date = params[:date] ? DateTime.parse(params[:date]) : DateTime.now
      if params[:direction]
        if params[:direction].include?('forward')
          date =  @date + 1.months
        elsif params[:direction].include?('back')
          date = @date - 1.months
        end
      else
        date = @date
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
