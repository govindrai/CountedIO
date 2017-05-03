class AddColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :maintenance_calories, :integer, null:false
    add_column :users, :weight_direction, :string, null:false
    add_column :users, :target_calories, :integer, null:false
  end
end
