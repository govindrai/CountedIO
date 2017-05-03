class Meal < ApplicationRecord
  belongs_to :user

  def self.get_day_meals(user, date_obj)
    Meal.where("user_id = ? AND created_at >= ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime)
  end

  def self.get_day_breakfast(user, date_obj)
    Meal.where("user_id = ? AND created_at >= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, "Breakfast")
  end

  def self.get_day_lunch(user, date_obj)
    Meal.where("user_id = ? AND created_at >= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, "Lunch")
  end

  def self.get_day_dinner(user, date_obj)
    Meal.where("user_id = ? AND created_at >= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, "Dinner")
  end

  def self.get_day_snack(user, date_obj)
    Meal.where("user_id = ? AND created_at >= ? AND meal_type = ?", user.id, (date_obj.beginning_of_day.to_time - 7.hours).to_datetime, "Snack")
  end

  def self.get_pie_chart_data(user, date_obj)
    meal_labels =  ["Breakfast", "Lunch", "Dinner", "Snack", "Remaining Calories"]
    calories_summary = user.get_calories_summary_num ? user.get_calories_summary_num : 0
    meal_values = [Meal.get_day_breakfast(user, date_obj).sum(:calories), Meal.get_day_lunch(user, date_obj).sum(:calories), Meal.get_day_dinner(user, date_obj).sum(:calories), Meal.get_day_snack(user, date_obj).sum(:calories), calories_summary]
    package = [meal_labels, meal_values]
  end

end
