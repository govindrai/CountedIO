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
      @date = params[:date] ? DateTime.parse(params[:date]) : DateTime.now
      @meals = @user.get_all_meals(@date)
      if params[:direction]
        if params[:direction].include?('forward')
          @date += 1
        elsif params[:direction].include?('back')
          @date -= 1
        end
      end
      data = {data: @user.get_pie_chart_data(@date), date: @date.strftime("%F"), labels: []}.to_json
      render json: data, layout:false
    end
  end

  def get_week_data
    if request.xhr?
      @date = params[:date] ? DateTime.parse(params[:date]) : DateTime.now
      if params[:direction]
        if params[:direction].include?('forward')
          date1 =  @date + 7
          date2 =  date1 + 7
        elsif params[:direction].include?('back')
          date1 = @date - 7
          date2 = @date
        end
      else
        date1 = @date - 7
        date2 = @date
      end
      data = {data: @user.get_bar_chart_data(date1), date: User.generate_week_label(date1, date2), labels: @user.get_bar_chart_labels(@date), target_calories: @user.get_target_calories_week}.to_json
      render json: data, layout:false
    end
  end

  def get_month_data
    if request.xhr?
      @date = params[:date] ? DateTime.parse(params[:date]).beginning_of_month : DateTime.now.beginning_of_month
      if params[:direction]
        if params[:direction].include?('forward')
          date =  @date + 1.months
        elsif params[:direction].include?('back')
          date = @date - 1.months
        end
      else
        date = @date
      end

      data = {data: @user.get_line_chart_data(date), date: User.generate_month_label(date), labels: @user.get_line_chart_labels(date), target_calories: @user.get_target_calories_month(@date)}.to_json
      render json: data, layout:false
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
