class User < ApplicationRecord
  has_many :meals, dependent: :destroy
  has_many :messages, dependent: :destroy

  before_save :generate_randomized_profile_url

  def generate_randomized_profile_url
    random = %w(a b c d e f g h i j k l m n o p q r s t u v w y z A B C D E F G H I J K L M N O P Q R S T U V W Y Z 1 2 3 4 5 6 7 8 9)

    random_url = ''
    10.times {|time| random_url += random.sample }
    self.randomized_profile_url = random_url
  end

  def generate_link_to_profile
    random = %w(a b c d e f g h i j k l m n o p q r s t u v w y z A B C D E F G H I J K L M N O P Q R S T U V W Y Z 1 2 3 4 5 6 7 8 9)
    base_url = "https://vildeio.herokuapp.com/profile/#{self.id}?random="
    generate_randomized_profile_url
    random_url = self.randomized_profile_url
    message = "Here is your profile:  "
    message + base_url + random_url
  end

  def get_calories_summary
    calories_consumed = self.meals.where("created_at >= ?", Time.now.beginning_of_day.in_time_zone("Pacific Time (US & Canada)")).pluck(:calories).inject {|acc, sum| acc + sum }
    if calories_consumed
      remaining_calories = (get_suggested_calories - calories_consumed).to_s
    else
      remaining_calories = get_suggested_calories.to_s
    end
    message = "You have consumed #{calories_consumed} calories today. You may only consume #{remaining_calories} more to meet your daily goal."
  end

  def get_suggested_calories
    activity_level = {"Sitting all day": 1.2, "Seated work, no exercise": 1.3, "Seated work, light exercise": 1.4, "Moderately physical, no exercise": 1.5, "Moderately physical work, light exercise": 1.6, "Moderately physical work, heavy exercise": 1.7, "Heavy work/ heavy exercise": 1.8, "Above average physical activity": 2}

    if self.sex == "male" || self.sex =="Male"
      (1.4 * suggested_male_calories).round()
    else
      (1.4 * suggested_female_calories).round()
    end
  end

  def suggested_male_calories
    bmr = 10 * (self.weight_pounds * 0.453592) + 6.25 * (self.height_inches * 2.54) - 5 * self.age + 5
  end

  def suggested_female_calories
    bmr = 10 * (seld.weight_pounds * 0.453592) + 6.25 * (self.height_inches * 2.54) - 5 * self.age - 161
  end



end
