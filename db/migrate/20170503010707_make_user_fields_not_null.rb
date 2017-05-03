class MakeUserFieldsNotNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :users, :target_calories, false
    change_column_null :users, :weight_direction, false
    change_column_null :users, :maintenance_calories, false
    change_column_null :users, :weight_direction, false
    change_column_null :users, :randomized_profile_url, false
  end
end
