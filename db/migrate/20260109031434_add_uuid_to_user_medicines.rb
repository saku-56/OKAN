class AddUuidToUserMedicines < ActiveRecord::Migration[7.2]
  def change
    add_column :user_medicines, :uuid, :uuid, default: 'gen_random_uuid()', null: false

    add_index :user_medicines, :uuid, unique: true
  end
end
