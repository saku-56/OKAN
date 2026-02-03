class ConsultationSchedule < ApplicationRecord
  belongs_to :user
  belongs_to :hospital

  enum :status, { scheduled: 0, completed: 1 }

  validates :visit_date, presence: true
  validates :status, presence: :true
  validate :visit_date_cannot_be_in_the_past

  scope :upcoming, -> { where(status: :scheduled).where("visit_date >= ?", Date.current).order(:visit_date) }
  scope :past_scheduled, -> { where("visit_date < ?", Date.current) }

  private

  def visit_date_cannot_be_in_the_past
    if visit_date.present? && visit_date < Date.current
      errors.add(:visit_date, "は今日以降の日付を選択してください")
    end
  end
end
