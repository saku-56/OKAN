class AddIsRegularToUserMedicines < ActiveRecord::Migration[7.2]
  def change
    add_column :user_medicines, :is_regular, :boolean, default: true
  end
end
