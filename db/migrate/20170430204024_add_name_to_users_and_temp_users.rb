class AddNameToUsersAndTempUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :temp_users, :name, :string
  end
end
