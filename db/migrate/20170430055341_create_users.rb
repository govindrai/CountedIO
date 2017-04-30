class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :phone_number
      t.integer :age
      t.integer :weight_pounds
      t.integer :height_inches
      t.string :target_weight_pounds
      t.string :sex
      t.string :randomized_profile_url

      t.timestamps
    end
  end
end
