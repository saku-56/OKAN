class UserMedicine < ApplicationRecord
  belongs_to :user

  # いつもの薬リストに表示する薬を取得
  scope :regular_medicines, -> { where(is_regular: true) }

  # 単発の薬を取得(本リリースで使用予定)
  scope :temporary_medicines, -> { where(is_regular: false) }
end
