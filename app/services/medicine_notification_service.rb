class MedicineNotificationService
  def self.notify_users
    User.joins(:notifications)
        .includes(:user_medicines, :notifications)
        .merge(Notification.active.medicine_stock)
        .find_each do |user|
        notify_user_medicines(user)
    end
  end

  def self.notify_user_medicines(user)
    user.user_medicines.each do |user_medicine|
      next unless should_notify?(user_medicine)

      send_line_notification(user_medicine)
    end
  end

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

  def self.send_line_notification(user_medicine)
    user = user_medicine.user
    message = build_notification_message(user_medicine)

    # LINE Messaging APIを使って通知を送信
    client = Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.credentials.line[:messaging_secret]
      config.channel_token = Rails.application.credentials.line[:messaging_token]
    end

    client.push_message(user.line_user_id, {
      type: "text",
      text: message
    })
  end

  def self.build_notification_message(user_medicine)
    days = user_medicine.user.notification.days_before
    medicine_name = user_medicine.medicine.name

    "【お薬の在庫通知】\n" \
    "#{medicine_name}の在庫があと#{days}日分となりました。\n" \
    "お早めに補充をお願いします。"
  end
end
