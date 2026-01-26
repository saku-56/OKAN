class AddUniqueIndexToHospitals < ActiveRecord::Migration[7.2]
  def change
    add_index :hospitals, [ :user_id, :name ], unique: true
  end
end
