class ChangeCurrentStockInUserMedicines < ActiveRecord::Migration[7.2]
  def change
    change_column_default :user_medicines, :current_stock, from: nil, to: 0
    change_column_null :user_medicines, :current_stock, false
  end
end
