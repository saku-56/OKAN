class HospitalSchedule < ApplicationRecord
  belongs_to :hospital

  enum day_of_week: { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6, holiday: 7 }
  enum period: { morning: 0, afternoon: 1 }

  validates :day_of_week, presence: true
  validates :period, presence: true

  before_validation :parse_time_strings

  validate :validate_time_range

  private

  def parse_time_strings
    # start_time が文字列（"09:00"）で来た場合、Time型に変換
    if start_time.is_a?(String) && start_time.present?
      hour, minute = start_time.split(":").map(&:to_i)
      self.start_time = Time.zone.parse("2000-01-01 #{hour}:#{minute}")
    elsif start_time.blank?
      self.start_time = nil
    end

    # end_time も同様
    if end_time.is_a?(String) && end_time.present?
      hour, minute = end_time.split(":").map(&:to_i)
      self.end_time = Time.zone.parse("2000-01-01 #{hour}:#{minute}")
    elsif end_time.blank?
      self.end_time = nil
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
      errors.add(:end_time, "は開始時間より遅い時刻に設定してください")
    end
  end
end
