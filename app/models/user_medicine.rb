class UserMedicine < ApplicationRecord
  belongs_to :user
  # UserMedicineはMedicineに属している
  belongs_to :medicine

  validates :medicine_id, uniqueness: { scope: :user_id }
  validates :dosage_per_time, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true }
  validates :prescribed_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true }
  # validates :current_stock, numericality: { greater_than_or_equal_to: 0 }
  validates :date_of_prescription, presence: true
  validate :date_of_prescription_cannot_be_in_future
  validates :uuid, uniqueness: true

  # 複数のレコードを絞り込む
  scope :has_stock, -> { where("current_stock > ?", 0) }

  # 1つのレコードの在庫があるか
  def has_stock?
    current_stock > 0
  end

  # カレンダーの日付を押した時の予想在庫数計算
  def stock_on(date)
    days_diff = (date - Date.current).to_i
    estimated = current_stock - days_diff * dosage_per_time
    # 在庫量がマイナス表示されないようにする
    [ estimated, 0 ].max
  end

  def display_stock_on(date)
    stock = self.stock_on(date)

    # 過去は表示しない
    return nil if date < Date.current

    # 今日
    if date == Date.current && stock.between?(1, 9)
      return stock
    end

    # 未来
    if date >= Date.current
      if stock == 10
        10
      end
    end
  end


  # 初回登録時、処方日と登録日が異なる場合の在庫量の計算
  def initial_stock_on_create
    return prescribed_amount if date_of_prescription == Date.current

    days_passed = (Date.current - date_of_prescription).to_i
    consumed = days_passed * dosage_per_time
    [ prescribed_amount - consumed, 0 ].max
  end

  def to_param
    uuid
  end


  def increment_stock
    update!(current_stock: current_stock + dosage_per_time)
  end

  private

  def date_of_prescription_cannot_be_in_future
    if date_of_prescription.present? && date_of_prescription > Date.current
      errors.add(:date_of_prescription, "は今日以前の日付を指定してください")
    end
  end
end
