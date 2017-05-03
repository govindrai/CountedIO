class ChangeTempUserColumn < ActiveRecord::Migration[5.0]
  def change
    change_column :temp_users, :target_weight_pounds, "integer USING target_weight_pounds::integer"
  end
end
