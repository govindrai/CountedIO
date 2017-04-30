class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :phone_number, null:false
      t.integer :age, null:false
      t.integer :weight_pounds, null:false
      t.integer :height_inches, null:false
      t.string :target_weight_pounds, null:false
      t.string :sex, null:false
      t.string :randomized_profile_url, null:false

      t.timestamps null:false
    end
  end
end
