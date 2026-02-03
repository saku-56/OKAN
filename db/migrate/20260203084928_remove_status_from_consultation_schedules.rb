class RemoveStatusFromConsultationSchedules < ActiveRecord::Migration[7.2]
  def change
    remove_column :consultation_schedules, :status, :integer
  end
end
