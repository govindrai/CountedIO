class User < ApplicationRecord
  has_many :meals, dependent: :destroy
  has_many :messages, dependent: :destroy

  before_create :generate_randomized_profile_url, :set_maintenance_calories, :set_weight_goal_values

  def generate_link_to_profile
    base_url = "https://vildeio.herokuapp.com/profile/#{self.id}?random="
    date = DateTime.now.strftime("%F")
    message = "Here is your profile:  " + base_url + generate_randomized_profile_url + "&date=" + date
  end

  def get_calories_summary
    calories_consumed = get_calories_summary_num
    if calories_consumed
      remaining_calories = (get_suggested_calories - calories_consumed).to_s
    else
      remaining_calories = get_suggested_calories.to_s
    end
    message = "You have consumed #{calories_consumed} calories today. You may only consume #{remaining_calories} more to meet your daily goal."
  end

  def get_calories_summary_num
    self.meals.where("created_at >= ?", Time.now.beginning_of_day.in_time_zone("Pacific Time (US & Canada)")).sum(:calories)
  end

  def time_to_success
    weeks = (self.target_weight_pounds - self.weight_pounds).to_i.abs
    days = weeks * 7
    date = (Date.today + days).strftime("%m/%d/%Y")
    "#{days} days (#{date})"
  end

  private

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
      self.target_calores = self.maintenance_calories
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
