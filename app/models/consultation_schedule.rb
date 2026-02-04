class ConsultationSchedule < ApplicationRecord
  belongs_to :user
  belongs_to :hospital

  validates :visit_date, presence: true
  validate :visit_date_within_six_months

  scope :upcoming, -> { where("visit_date >= ?", Date.current).order(:visit_date) }
  scope :past_scheduled, -> { where("visit_date < ?", Date.current) }

  private

  def visit_date_within_six_months
    return if visit_date.blank?

    if visit_date < Date.current
      errors.add(:visit_date, "は今日以降の日付を選択してください")
    elsif visit_date > Date.current + 6.months
      errors.add(:visit_date, "は半年以内の日付を選択してください")
    end
  end
end
