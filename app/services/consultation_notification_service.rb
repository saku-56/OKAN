require "line/bot"

class ConsultationNotificationService
  # LINE通知を送るユーザー
  def self.notify_users
    User.joins(:notifications)
        .includes(:consultation_schedules, :notifications)
        .merge(Notification.active.consultation_reminder)
        .find_each do |user|
          notify_consultation_schedules(user)
    end
  end

  # 通知を送る
  def self.notify_consultation_schedules(user)
    user.consultation_schedules.each do |consultation_schedule|
      next unless should_notify?(consultation_schedule)

      send_line_notification(consultation_schedule)
    end
  end

  # 今日通知を送るかどうか
  def self.should_notify?(consultation_schedule)
    # ユーザーの在庫通知設定を取得
    notification = consultation_schedule.user.notifications
                                        .find_by(notification_type: :consultation_reminder, enabled: true)
    return false if notification.blank?

    # 通院予定日からdays_before日引いた日が今日かどうか判定
    (consultation_schedule.visit_date - notification.days_before.days) == Date.current
  end

  # 通知の内容
  def self.send_line_notification(consultation_schedule)
    line_user_id = consultation_schedule.user.line_user_id
    return unless line_user_id.present?

    notification = consultation_schedule.user.notifications
                                        .find_by(notification_type: :consultation_reminder, enabled: true)

    hospital_name = consultation_schedule.hospital.name
    days = notification.days_before

    message = Line::Bot::V2::MessagingApi::TextMessage.new(
      type: "text",
      text: "【通院予定日の通知】\n" \
            "#{hospital_name}への通院日は#{days}日後やで〜。\n" \
            "忘れたあかんで〜。",
    )

    # プッシュメッセージリクエストを作成
    push_request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
      to: line_user_id,
      messages: [ message ],
    )
    begin
      response = LINE_BOT_CLIENT.push_message(push_message_request: push_request)
      true
    rescue => e
      false
    end
  end
end
