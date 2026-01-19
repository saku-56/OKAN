class RemoveMedicineNameFromUserMedicines < ActiveRecord::Migration[7.2]
  def change
    remove_column :user_medicines, :medicine_name, :string
    remove_column :user_medicines, :is_regular, :boolean

    add_reference :user_medicines, :medicine, null: false, foreign_key: true

    add_index :user_medicines, [ :user_id, :medicine_id ], unique: true
  end
end
