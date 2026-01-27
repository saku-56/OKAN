class HospitalSchedule < ApplicationRecord
  belongs_to :hospital

  enum day_of_week: { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6, holiday: 7 }
  enum period: { morning: 0, afternoon: 1 }

  validates :day_of_week, presence: true, if: :has_time?
  validates :period, presence: true, if: :has_time?

  validate :validate_time_range
  validate :validate_time_format
  before_validation :normalize_time_format

  private

  def has_time?
    start_time.present? || end_time.present?
  end

  def normalize_time_format
    self.start_time = format_time_string(start_time) if start_time.is_a?(String)
    self.end_time = format_time_string(end_time) if end_time.is_a?(String)
  end

  def format_time_string(value)
    return nil if value.blank?

    # "9:00" -> "09:00" に正規化
    if value.match(/^(\d{1,2}):(\d{1,2})$/)
      hour = $1.to_i
      minute = $2.to_i
      return nil if hour > 23 || minute > 59
      format("%02d:%02d", hour, minute)
    end

    value
  end

  def validate_time_format
    validate_single_time_format(:start_time)
    validate_single_time_format(:end_time)
  end

  def validate_single_time_format(field)
    value = send(field)
    return if value.blank?

    unless value.to_s.match?(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/)
      errors.add(field, "は時刻形式で入力してください（例: 9:00, 09:00）")
    end
  end

  def validate_time_range
    # 開始時間があるのに終了時間がない場合
    if start_time.present? && end_time.blank?
      errors.add(:end_time, "を入力してください")
      return
    end

    # 終了時間があるのに開始時間がない場合
    if end_time.present? && start_time.blank?
      errors.add(:start_time, "を入力してください")
      return
    end

    # 両方入力されている場合は、開始時間 < 終了時間をチェック
    if start_time.present? && end_time.present? && start_time > end_time
      errors.add(:end_time, "は開始時間より後に設定してください")
    end
  end
end
