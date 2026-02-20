class Hospital < ApplicationRecord
  # 暗号化
  encrypts :name, deterministic: true

  belongs_to :user
  has_many :hospital_schedules, dependent: :destroy
  has_many :consultation_schedules, dependent: :destroy

  accepts_nested_attributes_for :hospital_schedules, allow_destroy: true

  validates :name, presence: true, length: { maximum: 20 }, uniqueness: { scope: :user_id }
  validates :description, length: { maximum: 100 }
  validates :uuid, uniqueness: true

  def to_param
    uuid
  end
end
