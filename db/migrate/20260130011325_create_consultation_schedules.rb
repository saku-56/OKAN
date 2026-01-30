class CreateConsultationSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :consultation_schedules do |t|
      t.references :user, null: false, foreign_key: true
      t.references :hospital, null: false, foreign_key: true
      t.date :visit_date, null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end
  end
end
