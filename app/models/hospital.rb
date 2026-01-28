class Hospital < ApplicationRecord
  belongs_to :user
  has_many :hospital_schedules, dependent: :destroy

  accepts_nested_attributes_for :hospital_schedules, allow_destroy: true

  validates :name, presence: true, length: { maximum: 20 }
  validates :description, length: { maximum: 100 }
  validates :uuid, uniqueness: true
end
