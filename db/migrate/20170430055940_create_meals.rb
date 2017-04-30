class CreateMeals < ActiveRecord::Migration[5.0]
  def change
    create_table :meals do |t|
      t.references :user, foreign_key: true
      t.string :food_name, null:false
      t.integer :calories, null:false
      t.integer :quantity, null:false
      t.string :meal_type, null:false

      t.timestamps null:false
    end
  end
end
