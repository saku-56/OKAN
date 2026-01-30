class ConsultationSchedule < ApplicationRecord
  belongs_to :user
  belongs_to :hospital

  enum :status, { scheduled: 0, completed: 1, cancelled: 2 }

  validates :visit_date, presence: true
  validates :status, presence: :ture
end
