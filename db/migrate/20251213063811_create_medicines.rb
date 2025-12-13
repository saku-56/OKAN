class CreateMedicines < ActiveRecord::Migration[7.2]
  def change
    create_table :medicines do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :dosage_per_time, null: false

      t.timestamps
    end
  end
end
