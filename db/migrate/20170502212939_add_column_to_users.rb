class AddColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :original_description, :string, null:false
  end
end
