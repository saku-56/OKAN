class RemoveMedicineColumnsFromUserMedicines < ActiveRecord::Migration[7.2]
  def change
    remove_column :user_medicines, :medicine_name, :string
    remove_column :user_medicines, :dosage_per_time, :integer
  end
end
