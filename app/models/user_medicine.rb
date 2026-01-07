class UserMedicine < ApplicationRecord
  belongs_to :user

  validates :medicine_name, presence: true

  validates :dosage_per_time, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true }

  validates :prescribed_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true }

  validates :current_stock, numericality: { greater_than_or_equal_to: 0 }

  # いつもの薬リストに表示する薬を取得
  scope :regular_medicines, -> { where(is_regular: true) }

  # 単発の薬を取得(本リリースで使用予定)
  scope :temporary_medicines, -> { where(is_regular: false) }

  scope :with_current_stock, -> { where("current_stock > 0").order(created_at: :asc) }

  # カレンダーの日付を押した時の予想在庫数計算
  def stock_on(date)
    days_diff = (date - Date.current).to_i
    estimated = current_stock - days_diff * dosage_per_time
    # 在庫量がマイナス表示されないようにする
    [ estimated, 0 ].max
  end
end
