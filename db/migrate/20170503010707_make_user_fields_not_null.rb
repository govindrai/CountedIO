class MakeUserFieldsNotNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :users, :target_calories, true
    change_column_null :users, :weight_direction, true
    change_column_null :users, :maintenance_calories, true
    change_column_null :users, :weight_direction, true
    change_column_null :users, :randomized_profile_url, true
  end
end
