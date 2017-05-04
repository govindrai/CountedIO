class User < ApplicationRecord
  has_many :meals, dependent: :destroy
  has_many :messages, dependent: :destroy

  before_create :generate_randomized_profile_url, :set_maintenance_calories, :set_weight_goal_values

  def get_calories_consumed
    self.meals.where("created_at >= ?", Time.now.beginning_of_day.in_time_zone("Pacific Time (US & Canada)")).sum(:calories)
  end

  def time_to_success
    weeks = (self.target_weight_pounds - self.weight_pounds).to_i.abs
    days = weeks * 7
    date = (Date.today + days).strftime("%m/%d/%Y")
    "#{days} days (#{date})"
  end

  def get_day_meals(date_obj)
    [Meal.get_day_breakfast(date_obj), Meal.get_day_lunch(date_obj), Meal.get_day_dinner(date_obj), Meal.get_day_snack( date_obj)]
  end

  def get_day_breakfast(date_obj)
    Meal.where("user_id = ? AND created_at >= ? AND created_at <= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime + 1.days, "Breakfast")
  end

  def get_day_lunch(date_obj)
    Meal.where("user_id = ? AND created_at >= ? AND created_at <= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime + 1.days, "Lunch")
  end

  def get_day_dinner(date_obj)
    Meal.where("user_id = ? AND created_at >= ? AND created_at <= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime + 1.days, "Dinner")
  end

  def get_day_snack(date_obj)
    Meal.where("user_id = ? AND created_at >= ? AND created_at <= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime + 1.days, "Snack")
  end

  def get_pie_chart_data(user, date_obj)
    calories_eaten = user.get_calories_summary_num
    puts("CALORIES EATEN BRUH:", calories_eaten)
    calories_remaining = user.target_calories - calories_eaten
    calories_remaining = 0 if calories_remaining < 0

    meal_values = [Meal.get_day_breakfast(user, date_obj).sum(:calories), Meal.get_day_lunch(user, date_obj).sum(:calories), Meal.get_day_dinner(user, date_obj).sum(:calories), Meal.get_day_snack(user, date_obj).sum(:calories), calories_remaining]
  end

  def self.get_meal_types
    ['Breakfast', 'Lunch', 'Dinner', 'Snack']
  end

  private

  def convertToPST(datetime)

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
