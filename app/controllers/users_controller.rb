class UsersController < ApplicationController
  before_action :set_user
  include LinkHelper

  def show
    if @user.authorized?(params[:random])
      @date = params[:date] ? DateTime.parse(params[:date]) : DateTime.now
      @meals = @user.get_all_meals(@date)

      if request.xhr?
        if params[:direction] == 'forward'
          @date += 1
        else
          @date -= 1
        end
        data = {data: @user.get_pie_chart_data(@date), date: @date.strftime("%F")}.to_json
        render json: data, layout:false
      else
        @chart_data = @user.get_pie_chart_data(@date)
      end
    else
      render plain: "USER NOT AUTHORIZED"
    end
  end

  def get_day_data
    if request.xhr?
      @date = DateTime.parse(params[:date])
      @meals = @user.get_all_meals(@date)
      if params[:direction] == 'forward'
        @date += 1
      else
        @date -= 1
      end
      data = {data: @user.get_pie_chart_data(@date), date: @date.strftime("%F")}.to_json
      render json: data, layout:false
    end
  end

  def get_week_data
    if request.xhr?
      @date = DateTime.parse(params[:date])
      puts @date
      if params[:direction].include?('forward')
        date1 =  @date + 7
        date2 =  date1 + 7
        puts date1
        puts date2
      else
        date1 = @date - 7
        date2 = @date
      end
      data = {data: @user.get_bar_chart_data(date1), date: User.generate_week_label(date1, date2)}.to_json
      render json: data, layout:false
    end
  end

  def get_month_data
    if request.xhr?
      @date = DateTime.parse(params[:date])
      puts @date
      if params[:direction].include?('forward')
        date1 =  @date + 7
        date2 =  date1 + 7
        puts date1
        puts date2
      else
        date1 = @date - 7
        date2 = @date
      end
      data = {data: @user.get_line_chart_data(date1), date: User.generate_month_label(date1)}.to_json
      render json: data, layout:false
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
