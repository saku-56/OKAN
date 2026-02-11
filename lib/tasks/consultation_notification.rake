namespace :consultation_notification do
  desc "通院予定通知を送信する"
  task send_notification: :environment do
    puts "通院予定通知の送信を開始します..."

    ConsultationNotificationService.notify_users

    puts "通院予定通知の送信が完了しました。"
  end
end
