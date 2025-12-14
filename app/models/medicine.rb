class Medicine < ApplicationRecord
  belongs_to :user
  has_many :user_medicines, dependent: :nullify

  validates :name, presence: true
  validates :dosage_per_time, presence: true, numericality: { greater_than: 0 }
end
