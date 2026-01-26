class CreateHospitalSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :hospital_schedules do |t|
      t.integer :day_of_week, null: false
      t.integer :period, null: false
      t.time :start_time
      t.time :end_time
      t.references :hospital, null: false, foreign_key: true
      t.timestamps
    end
  end
end
