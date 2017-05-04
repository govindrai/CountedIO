class User < ApplicationRecord
  include DateHelper

  has_many :meals, dependent: :destroy
  has_many :messages, dependent: :destroy

  before_create :generate_randomized_profile_url, :set_maintenance_calories, :set_weight_goal_values

  # works for both line and bar graphs
  def get_chart_data(date, range)
    days = range == "Week" ? 7 : get_days_in_month(date)
    Array.new(days) do |x|
      meal_values = self.get_pie_chart_data(date + x)
      meal_values.pop
      meal_values.inject(0,:+)
    end
  end

  # works for both line and bar graphs
  def get_chart_data_labels(date, range)
    days = range == "Week" ? 7 : get_days_in_month(date)
    if days == 7
      Array.new(days) { |x| get_weekday(date - (6 - x).days) }
    else
      Array.new(days) { |x| x + 1 }
    end
  end

  def get_target_calories(date, range)
    days = range == "Week" ? 7 : get_days_in_month(date)
    Array.new(days, self.target_calories)
  end

  def get_calories_consumed(date)
    self.meals.where("created_at >= ? AND created_at <= ?", date_to_PST(date)[0],date_to_PST(date)[1]).sum(:calories)
  end

  def get_all_meals(date)
    [get_meals(date, "Breakfast"), get_meals(date, "Lunch"), get_meals(date, "Dinner"), get_meals(date, "Snack")]
  end

  def get_meals(date, meal_type)
    self.meals.where("created_at >= ? AND created_at <= ? AND meal_type = ?", date_to_PST(date)[0],date_to_PST(date)[1], meal_type)
  end

  def get_pie_chart_data(date)
    calories_remaining = self.target_calories - get_calories_consumed(date) < 0 ? 0 : self.target_calories - get_calories_consumed(date)
    [get_meals(date, 'Breakfast').sum(:calories), get_meals(date, 'Lunch').sum(:calories), get_meals(date, 'Dinner').sum(:calories), get_meals(date, 'Snack').sum(:calories), calories_remaining]
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

  def get_profile_url
    "https://vildeio.herokuapp.com/profile/#{self.id}?random=#{generate_randomized_profile_url}"
  end

  def generate_randomized_profile_url
    random = %w(a b c d e f g h i j k l m n o p q r s t u v w y z A B C D E F G H I J K L M N O P Q R S T U V W Y Z 1 2 3 4 5 6 7 8 9)
    random_url = ''
    10.times {|time| random_url += random.sample }
    self.randomized_profile_url = random_url
  end

  def self.date_to_PST(date)
    [date.beginning_of_day.in_time_zone("Pacific Time (US & Canada)"), date.beginning_of_day.in_time_zone("Pacific Time (US & Canada)") + 1.days]
  end

  private

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
    if self.sex.downcase == "male"
      self.maintenance_calories = (1.4 * bmr_formula_male).round
    else
      self.maintenance_calories = (1.4 * bmr_formula_female).round
    end
  end

  def bmr_formula_male
    10 * (self.weight_pounds * 0.453592) + 6.25 * (self.height_inches * 2.54) - 5 * self.age + 5
  end

  def bmr_formula_female
    10 * (self.weight_pounds * 0.453592) + 6.25 * (self.height_inches * 2.54) - 5 * self.age - 161
  end
end
