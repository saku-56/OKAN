class UserMedicine < ApplicationRecord
  belongs_to :user
  # UserMedicineはMedicineに属している
  belongs_to :medicine

  validates :medicine_id, uniqueness: { scope: :user_id }
  validates :dosage_per_time, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true }
  validates :times_per_day, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4 }
  validates :prescribed_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true }
  # validates :current_stock, numericality: { greater_than_or_equal_to: 0 }
  validates :date_of_prescription, presence: true
  validates :uuid, uniqueness: true
  validate :date_of_prescription_cannot_be_in_future

  # 複数のレコードを絞り込む
  scope :has_stock, -> { where("current_stock > ?", 0) }

  # 1つのレコードの在庫があるか
  def has_stock?
    current_stock > 0
  end

  # 在庫切れ予定日を計算するメソッド
  def stock_out_date
    return nil if daily_dosage <= 0 || current_stock <= 0

    days_until_stock_out = (current_stock / daily_dosage.to_f).floor
    Date.current + days_until_stock_out.days
  end

  # カレンダーの日付を押した時の予想在庫数計算
  def stock_on(date)
    days_diff = (date - Date.current).to_i
    estimated = current_stock - days_diff * daily_dosage
    # 在庫量がマイナス表示されないようにする
    [ estimated, 0 ].max
  end

  # カレンダーに表示する情報を返すメソッド
  def display_stock_on(date)
    # 過去は表示しない
    return nil if date < Date.current

    stock_out = stock_out_date
    return nil if stock_out.nil?

    # 在庫切れ予定日の場合に表示
    if date == stock_out
      return "在庫切れ予定"
    end

    nil
  end

  # 初回登録時、処方日と登録日が異なる場合の在庫量の計算
  def initial_stock_on_create
    return prescribed_amount if date_of_prescription == Date.current

    days_passed = (Date.current - date_of_prescription).to_i
    consumed = days_passed * daily_dosage
    [ prescribed_amount - consumed, 0 ].max
  end

  def to_param
    uuid
  end

  def increment_stock
    update!(current_stock: current_stock + dosage_per_time)
  end

  # 1日の服薬量
  def daily_dosage
    dosage_per_time * times_per_day
  end

  private

  def date_of_prescription_cannot_be_in_future
    if date_of_prescription.present? && date_of_prescription > Date.current
      errors.add(:date_of_prescription, "は今日までの日付を選択してください")
    end
  end
end
