require "line/bot"

class MedicineNotificationService
  def self.client
    @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: Rails.application.credentials.dig(:line, :messaging_channel_access_token),
    )
  end

  # LINE通知を送るユーザー
  def self.notify_users
    User.joins(:notifications)
        .includes(:user_medicines, :notifications)
        .merge(Notification.active.medicine_stock)
        .find_each do |user|
      notify_user_medicines(user)
    end
  end

  # 通知を送る
  def self.notify_user_medicines(user)
    user.user_medicines.each do |user_medicine|
      next unless should_notify?(user_medicine)

      send_line_notification(user_medicine)
    end
  end

  # 今日通知を送るかどうか
  def self.should_notify?(user_medicine)
    stock_out_date = user_medicine.stock_out_date
    return false if stock_out_date.blank?

    # ユーザーの在庫通知設定を取得
    notification = user_medicine.user.notifications
                                .find_by(notification_type: :medicine_stock, enabled: true)
    return false if notification.blank?

    # 在庫切れ予定日からdays_before日引いた日が今日かどうか判定
    (stock_out_date - notification.days_before.days) == Date.current
  end

  # 通知の内容
  def self.send_line_notification(user_medicine)
    line_user_id = user_medicine.user.line_user_id
    return unless line_user_id.present?

    notification = user_medicine.user.notifications
                                .find_by(notification_type: :medicine_stock, enabled: true)

    days = notification.days_before
    medicine_name = user_medicine.medicine.name

    message = Line::Bot::V2::MessagingApi::TextMessage.new(
      type: "text",
      text: "【お薬の在庫通知】\n" \
            "#{medicine_name}の在庫があと#{days}日分となりました。",
    )

    # プッシュメッセージリクエストを作成
    push_request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
      to: line_user_id,
      messages: [ message ],
    )
    begin
      response = client.push_message(push_message_request: push_request)
      true
    rescue => e
      false
    end
  end
end
