class UserMedicineForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :medicine_name, :string
  attribute :dosage_per_time, :integer
  attribute :prescribed_amount, :integer
  attribute :date_of_prescription, :date

  validates :medicine_name, presence: true, length: { maximum: 20 }
  validates :dosage_per_time, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true }
  validates :prescribed_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true }
  validates :date_of_prescription, presence: true
  validate :date_of_prescription_cannot_be_in_future
  validate :medicine_not_duplicated

  def initialize(attributes = {})
    # attributesハッシュから:userキーを取り出して削除(userはフォームオブジェクトの属性ではないため)
    @user = attributes.delete(:user)
    super(attributes)
  end

  def save
    # フォームオブジェクトに設定したバリデーションを実行
    return false unless valid?

    ActiveRecord::Base.transaction do
      medicine = @user.medicines.find_or_create_by!(name: medicine_name)

      user_medicine = @user.user_medicines.build(
        medicine: medicine,
        dosage_per_time: dosage_per_time,
        prescribed_amount: prescribed_amount,
        date_of_prescription: date_of_prescription
      )

      user_medicine.current_stock = user_medicine.initial_stock_on_create

      unless user_medicine.save
        # モデルのエラーをフォームオブジェクトに転記
        user_medicine.errors.each do |error|
          errors.add(error.attribute, error.message)
        end
        raise ActiveRecord::Rollback
      end

      @user_medicine = user_medicine
      true
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end

  private

  def date_of_prescription_cannot_be_in_future
    if date_of_prescription.present? && date_of_prescription > Date.today
      errors.add(:date_of_prescription, "は今日までの日付を選択してください")
    end
  end

  def medicine_not_duplicated
    return if medicine_name.blank? || @user.nil?

    medicine = Medicine.find_by(name: medicine_name)
    if medicine && @user.user_medicines.exists?(medicine: medicine)
      errors.add(:medicine_name, "は既に登録されています")
    end
  end
end
