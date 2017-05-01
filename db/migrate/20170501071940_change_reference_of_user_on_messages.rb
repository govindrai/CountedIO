class ChangeReferenceOfUserOnMessages < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :user_id
    add_column :messages, :user_id, :integer, index: true
  end
end
