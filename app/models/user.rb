class User < ApplicationRecord
  has_many :meals, dependent: :destroy
  has_many :messages, dependent: :destroy

  before_create :generate_randomized_profile_url, :set_maintenance_calories, :set_weight_goal_values

  def some_method
    if authorized(params[:random])
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

        @chart_data = {data: Meal.get_pie_chart_data(@user, @date), date: @date.strftime("%F")}.to_json
        render json: @chart_data, layout:false
      else
        @chart_data = Meal.get_pie_chart_data(@user, @date)
      end
    end
  end

  def get_calories_consumed
    self.meals.where("created_at >= ? AND create_at <=", today_PST, tomorrow_PST).sum(:calories)
  end

  def get_all_meals(date)
    [get_meals(date, "Breakfast"), get_meals(date, "Lunch"), get_meals(date, "Dinner"), get_meals(date, "Snack")]
  end

  def get_meals(date, meal_type)
    self.meals.where("created_at >= ? AND created_at <= ? AND meal_type = ?", today_PST, tomorrow_PST, meal_type)
  end

  def get_pie_chart_data(date)
    calories_remaining = user.target_calories - get_calories_consumed
    calories_remaining = 0 if calories_remaining < 0
    meal_values = [get_meals(date, 'Breakfast').sum(:calories), get_meals(date, 'Lunch').sum(:calories), get_meals(date, 'Dinner').sum(:calories), get_meals(date, 'Snack').sum(:calories), calories_remaining]
  end

  def get_time_to_success
    weeks = (self.target_weight_pounds - self.weight_pounds).to_i.abs
    days = weeks * 7
    date = (Date.today + days).strftime("%m/%d/%Y")
    "#{days} days (#{date})"
  end

  def authorized?(url_param)
    self.randomized_profile_url == url_param
  end

  private

  def today_PST
    Time.now.beginning_of_day.in_time_zone("Pacific Time (US & Canada)")
  end

  def tomorrow_PST
    Time.now.beginning_of_day.in_time_zone("Pacific Time (US & Canada)") + 1.days
  end

  def generate_randomized_profile_url
    random = %w(a b c d e f g h i j k l m n o p q r s t u v w y z A B C D E F G H I J K L M N O P Q R S T U V W Y Z 1 2 3 4 5 6 7 8 9)
    random_url = ''
    10.times {|time| random_url += random.sample }
    self.randomized_profile_url = random_url
  end

  # sets weight direction and target calories
  def set_weight_goal_values
    if self.target_weight_pounds < self.weight_pounds
      self.weight_direction = "Weight Loss"
      self.target_calories = self.maintenance_calories - 500
    elsif self.target_weight_pounds > self.weight_pounds
      self.weight_direction = "Weight Gain"
      self.target_calories = self.maintenance_calories + 500
    else
      self.weight_direction = "Maintain Weight"
      self.target_calories = self.maintenance_calories
    end
  end

  def set_maintenance_calories
    activity_level = {"Sitting all day": 1.2, "Seated work, no exercise": 1.3, "Seated work, light exercise": 1.4, "Moderately physical, no exercise": 1.5, "Moderately physical work, light exercise": 1.6, "Moderately physical work, heavy exercise": 1.7, "Heavy work/ heavy exercise": 1.8, "Above average physical activity": 2}

    if self.sex == "male" || self.sex =="Male"
      self.maintenance_calories = (1.4 * bmr_formula_male).round()
    else
      self.maintenance_calories = (1.4 * bmr_formula_female).round()
    end
  end

  def bmr_formula_male
    bmr = 10 * (self.weight_pounds * 0.453592) + 6.25 * (self.height_inches * 2.54) - 5 * self.age + 5
  end

  def bmr_formula_female
    bmr = 10 * (self.weight_pounds * 0.453592) + 6.25 * (self.height_inches * 2.54) - 5 * self.age - 161
  end
end
