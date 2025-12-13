class AddMedicineIdToUserMedicines < ActiveRecord::Migration[7.2]
  def change
    add_reference :user_medicines, :medicine, null: false, foreign_key: true
  end
end
