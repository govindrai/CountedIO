class CreateMeals < ActiveRecord::Migration[5.0]
  def change
    create_table :meals do |t|
      t.references :user, foreign_key: true
      t.string :food_name
      t.integer :calories
      t.integer :quantity
      t.string :meal_type

      t.timestamps
    end
  end
end
