namespace :medicine_stock do
  desc "日付が変わると服薬したものとして薬の在庫量が減る"
  task reduce_medicine_stock: :environment do
    UserMeidcine.with_current_stock.find_each  do |user_medicine|
      new_stock = user_medicine.current_stock - user_medicine.dosage_per_time
      # 在庫が0未満にならないようにする
      user_medicine.update(current_stock: [ new_stock, 0 ].max)
    end
  end
end
