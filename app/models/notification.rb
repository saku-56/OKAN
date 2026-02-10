class Notification < ApplicationRecord
  belongs_to :user

  enum notification_type: { medicine_stock: "medicine_stock", consultation_reminder: "consultation_reminder" }

  validates :notification_type, presence: true, uniqueness: { scope: :user_id }
  validates :days_before, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 7, allow_blank: true  }
end
