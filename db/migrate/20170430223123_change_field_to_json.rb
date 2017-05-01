class ChangeFieldToJson < ActiveRecord::Migration[5.0]
  def change
    change_column :messages, :json_wit_response, 'json USING json_wit_response::json'
  end
end
