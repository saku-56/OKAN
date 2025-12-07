class CreateUserMedicines < ActiveRecord::Migration[7.2]
  def change
    create_table :user_medicines do |t|
      t.string :medicine_name, null: false
      t.integer :dosage_per_time, null: false
      t.integer :prescribed_amount, null: false
      t.integer :current_stock
      t.date :date_of_prescription, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
