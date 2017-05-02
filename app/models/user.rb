class User < ApplicationRecord
  has_many :meals
  has_many :messages

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
    random_url = self.randomized_profile_url
    message = "Here is your profile:  "
    message + base_url + random_url
  end

  #This may have bugs
  def get_calories_summary
    calories_consumed = self.meals.where("created_at >= ?", Time.now.beginning_of_day.in_time_zone("Pacific Time (US & Canada)")).pluck(:calories).inject {|acc, sum| acc + sum }
    message = "You have consumed " + calories_consumed.to_s + " today."
  end

  def add_calories(message)
    calories = message.json_wit_response["entities"]["food_description"][0]["entities"]["number"][0]["value"]
    @meal = Meal.create(calories: calories, user: self, quantity: 1, food_name: '', meal_type: 'snack',  )
    message = "We have added " + calories.to_s + " to your account."
  end

end
