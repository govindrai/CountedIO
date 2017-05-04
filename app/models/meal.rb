class Meal < ApplicationRecord
  belongs_to :user

  def self.get_meal_types
    ['Breakfast', 'Lunch', 'Dinner', 'Snack']
  end
end
