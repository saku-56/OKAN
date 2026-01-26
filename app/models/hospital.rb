class Hospital < ApplicationRecord
  belongs_to :user
  has_one :hospital_schedule, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :description, length: { maximum: 50 }
  validates :uuid, uniqueness: true
end
