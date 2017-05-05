# gov = User.create(name:"govind", age:24, weight_pounds:190, target_weight_pounds:175, height_inches:70, sex:"male", phone_number: "+19257779777")

User.destroy_all
Meal.destroy_all

dan = User.create(name: "Daniel Welsh", phone_number: "+17802636496", age: 20, weight_pounds: 170, target_weight_pounds: 180, sex: "male", height_inches: 74)

food = ["Chicken", "Celery", "Waffles", "Ice Cream", "Cereal", "Sandwich", "Ham", "Grilled Chicken Breast", "Rice", "Cake", "Kush", "Wasabi", "Super Steak", "Strawberries", "Apples", "Orange", "Coffee", "Twinky", "Donuts", "Chicken and Rice", "Cheese Pizza", "Pepperoni Pizza", "Water", "Brie", "Crackers", "Figs"]

calories = [140,375,220,600,30,210,750,215,450,10,230,560,750,230,120,170,75,70,40,30]

meal_type = ["Breakfast", "Lunch", "Dinner", "Snack"]

quantity = [1,2,3,4]

original_description = ["lala"]

random_amount_of_days = []
150.times do |time|
  random_amount_of_days << time
end

1500.times do |time|
  Meal.create(user: dan, food_name: food.sample, calories: calories.sample, quantity: quantity.sample, meal_type: meal_type.sample, original_description: original_description[0], created_at: DateTime.now - random_amount_of_days.sample)
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
