class ChangeColumnInMessages < ActiveRecord::Migration[5.0]
  def change
    rename_column :messages, :WIT_JSON_output, :json_wit_response
  end
end
