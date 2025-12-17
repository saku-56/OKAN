class AddMedicineNameToUserMedicines < ActiveRecord::Migration[7.2]
  def change
    add_column :user_medicines, :medicine_name, :string,  null: false
    add_column :user_medicines, :dosage_per_time, :integer,  null: false
  end
end
