class AddTimesPerDayToUserMedicines < ActiveRecord::Migration[7.2]
  def change
    add_column :user_medicines, :times_per_day, :integer, default: 1, null: false
  end
end
