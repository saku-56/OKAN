class Medicine < ApplicationRecord
  belongs_to :user
  # Medicineは一つのUserMedicineを持つ
  has_one :user_medicine, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }, uniqueness: { scope: :user_id }
end
