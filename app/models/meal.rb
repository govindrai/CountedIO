class Meal < ApplicationRecord
  belongs_to :user


  def self.get_day_meals(user, date_obj)
    Meal.where("user_id = ? AND created_at >= ?", user.id, (date_obj.to_time + 7.hours).to_datetime)
  end

  def self.get_day_breakfast)user, date_obj)

  end

  def self.get_day_lunch(user, date_obj)

  end

  def self.get_day_dinner(user, date_obj)

  end

  def self.get_day_snack(user.date_obj)

  end

end
