# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# gov = User.create(name:"govind", age:24, weight_pounds:190, target_weight_pounds:175, height_inches:70, sex:"male", phone_number: "+19257779777")


# gov = User.create(name:"govind", age:24, weight_pounds:190, target_weight_pounds:175, height_inches:70, sex:"male", phone_number: "+19257779777")
User.destroy_all
Meal.destroy_all


dan = User.create(name: "Daniel Welsh", phone_number: "+17802636496", age: 20, weight_pounds: 170, target_weight_pounds: 180, sex: "male", height_inches: 74)

food = ["Chicken", "Celery", "Waffles", "Ice Cream", "Cereal", "Sandwich", "Ham", "Grilled Chicken Breast", "Rice", "Cake", "Kush"]

calories = [123,324,234,90,34,234,754,234]

meal_type = ["Breakfast", "Lunch", "Dinner", "Snack"]

quantity = [1,2,3,4]

original_description = ["lala"]

dates = [DateTime.now, DateTime.now - 1, DateTime.now - 2, DateTime.now - 3, DateTime.now - 4]


40.times do |time|
  Meal.create(user: dan, food_name: food.sample, calories: calories.sample, quantity: quantity.sample, meal_type: meal_type.sample, original_description: original_description[0], created_at: dates.sample)
end











# Meal.create(user: dan, food_name: "Chicken", calories: 123, quantity: 2, meal_type: "Breakfast", original_description: "lala")

# Meal.create(user: dan, food_name: "Celery", calories: 5, quantity: 5, meal_type: "Breakfast", original_description: "lala")

# Meal.create(user: dan, food_name: "Waffles", calories: 450, quantity: 2, meal_type: "Breakfast", original_description: "lala")

# Meal.create(user: dan, food_name: "Ice Cream", calories: 200, quantity: 1, meal_type: "Breakfast", original_description: "lala")

# Meal.create(user: dan, food_name: "Cereal", calories: 400, quantity: 1, meal_type: "Lunch", original_description: "lala")

# Meal.create(user: dan, food_name: "Sandwich", calories: 300, quantity: 1, meal_type: "Lunch", original_description: "lala")

# Meal.create(user: dan, food_name: "ham", calories: 150, quantity: 3, meal_type: "Dinner", original_description: "lala")

# Meal.create(user: dan, food_name: "Grilled Chicken Breast", calories: 300, quantity: 1, meal_type: "Dinner", original_description: "lala")

# Meal.create(user: dan, food_name: "Cake", calories: 300, quantity: 1, meal_type: "Dinner", original_description: "lala")

# Meal.create(user: dan, food_name: "Cake", calories: 500, quantity: 1, meal_type: "Dinner", original_description: "lala")



Meal.create(user: dan, food_name: "Chicken", calories: 123, quantity: 2, meal_type: "Breakfast", original_description: "lala", created_at: Date.yesterday)

Meal.create(user: dan, food_name: "Celery", calories: 5, quantity: 5, meal_type: "Breakfast", original_description: "lala")

Meal.create(user: dan, food_name: "Waffles", calories: 450, quantity: 2, meal_type: "Breakfast", original_description: "lala")

Meal.create(user: dan, food_name: "Ice Cream", calories: 200, quantity: 1, meal_type: "Breakfast", original_description: "lala")

Meal.create(user: dan, food_name: "Cereal", calories: 400, quantity: 1, meal_type: "Lunch", original_description: "lala")

Meal.create(user: dan, food_name: "Sandwich", calories: 300, quantity: 1, meal_type: "Lunch", original_description: "lala")

Meal.create(user: dan, food_name: "ham", calories: 150, quantity: 3, meal_type: "Dinner", original_description: "lala")

Meal.create(user: dan, food_name: "Grilled Chicken Breast", calories: 300, quantity: 1, meal_type: "Dinner", original_description: "lala")

Meal.create(user: dan, food_name: "Cake", calories: 300, quantity: 1, meal_type: "Dinner", original_description: "lala")

Meal.create(user: dan, food_name: "Cake", calories: 500, quantity: 1, meal_type: "Dinner", original_description: "lala")


# govind = User.create(name: "Govind Rai", phone_number: "+19257779777", age: 24, weight_pounds: 170, target_weight_pounds: 180, sex: "male", height_inches: 70)

# Meal.create(user: govind, food_name: "Chicken", calories: 123, quantity: 2, meal_type: "breakfast")

# Meal.create(user: govind, food_name: "Celery", calories: 5, quantity: 5, meal_type: "breakfast")

# Meal.create(user: govind, food_name: "Waffles", calories: 450, quantity: 2, meal_type: "breakfast")

# Meal.create(user: govind, food_name: "Ice Cream", calories: 200, quantity: 1, meal_type: "breakfast")

# Meal.create(user: govind, food_name: "Cereal", calories: 400, quantity: 1, meal_type: "Lunch")

# Meal.create(user: govind, food_name: "Sandwich", calories: 300, quantity: 1, meal_type: "Lunch")

# Meal.create(user: govind, food_name: "ham", calories: 150, quantity: 3, meal_type: "dinner")

# Meal.create(user: govind, food_name: "Grilled Chicken Breast", calories: 300, quantity: 1, meal_type: "dinner")

# Meal.create(user: govind, food_name: "Cake", calories: 300, quantity: 1, meal_type: "dinner")

# Meal.create(user: govind, food_name: "Weed", calories: 332, quantity: 1, meal_type: "dinner")

# Meal.create(user: govind, food_name: "cupcake", calories: 300213, quantity: 1, meal_type: "dinner")

# Meal.create(user: govind, food_name: "dank", calories: 3020, quantity: 1, meal_type: "dinner")

# Meal.create(user: govind, food_name: "Cake", calories: 300, quantity: 1, meal_type: "dinner")
