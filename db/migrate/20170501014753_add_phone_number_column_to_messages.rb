class AddPhoneNumberColumnToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :phone_number, :string, null:false
  end
end
