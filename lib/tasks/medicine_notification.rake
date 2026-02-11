namespace :medicine_notification do
  desc "在庫通知を送信する"
  task send_notification: :environment do
    puts "在庫通知の送信を開始します..."

    MedicineNotificationService.notify_users

    puts "在庫通知の送信が完了しました。"
  end
end
