class Meal < ApplicationRecord
  belongs_to :user

  def self.get_day_meals(user, date_obj)
    # Meal.where("user_id = ? AND created_at >= ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime)
    [Meal.get_day_breakfast(user, date_obj), Meal.get_day_lunch(user, date_obj), Meal.get_day_dinner(user, date_obj), Meal.get_day_snack(user, date_obj)]
  end

  def self.get_day_breakfast(user, date_obj)
    puts "CREATED AT GREATER THAN"
    puts (date_obj.beginning_of_day.to_time - 7.hours).to_datetime
    puts "CREATED AT LESS THAN"
    puts (date_obj.beginning_of_day.to_time - 7.hours).to_datetime + 1.days
    Meal.where("user_id = ? AND created_at >= ? AND created_at <= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime + 1.days, "Breakfast")
  end

  def self.get_day_lunch(user, date_obj)
    Meal.where("user_id = ? AND created_at >= ? AND created_at <= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime + 1.days, "Lunch")
  end

  def self.get_day_dinner(user, date_obj)
    Meal.where("user_id = ? AND created_at >= ? AND created_at <= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime + 1.days, "Dinner")
  end

  def self.get_day_snack(user, date_obj)
    Meal.where("user_id = ? AND created_at >= ? AND created_at <= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime + 1.days, "Snack")
  end

  def self.get_pie_chart_data(user, date_obj)
    calories_eaten = user.get_calories_summary_num
    puts("CALORIES EATEN BRUH:", calories_eaten)
    calories_remaining = user.target_calories - calories_eaten
    calories_remaining = 0 if calories_remaining < 0

    meal_values = [Meal.get_day_breakfast(user, date_obj).sum(:calories), Meal.get_day_lunch(user, date_obj).sum(:calories), Meal.get_day_dinner(user, date_obj).sum(:calories), Meal.get_day_snack(user, date_obj).sum(:calories), calories_remaining]
  end

  def self.get_meal_types
    ['Breakfast', 'Lunch', 'Dinner', 'Snack']
  end

end
