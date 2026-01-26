class HospitalSchedule < ApplicationRecord
  belongs_to :hospital

  enum day_of_week: { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6, holiday: 7 }
  enum period: { morning: 0, afternoon: 1 }

  validates :day_of_week, presence: true, if: :has_time?
  validates :period, presence: true, if: :has_time?

  private

  def has_time?
    start_time.present? || end_time.present?
  end
end
