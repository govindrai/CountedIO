class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :user, foreign_key: true
      t.string :intent
      t.text :WIT_JSON_output

      t.timestamps
    end
  end
end
