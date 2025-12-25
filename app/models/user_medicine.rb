class UserMedicine < ApplicationRecord
  belongs_to :user

  validates :medicine_name, presence: true

  validates :dosage_per_time, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true }

  validates :prescribed_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true }

  # いつもの薬リストに表示する薬を取得
  scope :regular_medicines, -> { where(is_regular: true) }

  # 単発の薬を取得(本リリースで使用予定)
  scope :temporary_medicines, -> { where(is_regular: false) }

  # カレンダーの日付を押した時の予想在庫数計算
  def stock_on(date)
    # 処方日より前の日付の場合は計算しない
    return 0 if date < date_of_prescription

    days_diff = (date - Date.current).to_i
    estimated = current_stock - days_diff * dosage_per_time
    [ estimated, 0 ].max
  end
end
