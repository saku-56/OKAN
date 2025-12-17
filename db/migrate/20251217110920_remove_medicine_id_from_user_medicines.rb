class RemoveMedicineIdFromUserMedicines < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :user_medicines, column: :medicine_id
    remove_column :user_medicines, :medicine_id, :integer
  end
end
