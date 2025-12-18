class DropMedicines < ActiveRecord::Migration[7.2]
  def change
    drop_table :medicines
  end
end
