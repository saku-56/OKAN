namespace :medicine_stock do
  desc "日付が変わると服薬したものとして薬の在庫量が減る"
  task reduce_medicine_stock: :environment do
    puts "=== 在庫減算処理を開始 ==="

    success_count = 0
    error_count = 0

    UserMedicine.has_stock.find_each do |user_medicine|
      before_stock = user_medicine.current_stock
      new_stock = user_medicine.current_stock - user_medicine.daily_dosage

      if user_medicine.update(current_stock: [ new_stock, 0 ].max)
        success_count += 1
        puts "✓ ID:#{user_medicine.id} #{before_stock} → #{user_medicine.current_stock}"
      else
        error_count += 1
        puts "✗ ID:#{user_medicine.id} 更新失敗: #{user_medicine.errors.full_messages.join(', ')}"
      end
    end

    puts "=== 処理完了: 成功 #{success_count}件, 失敗 #{error_count}件 ==="
  end
end
