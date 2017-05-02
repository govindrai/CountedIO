class AddUnitToMeals < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :units, :string
  end
end
