FactoryBot.define do
  factory :notification do
    notification_type { :medicine_stock }
    enable { true }
    days_before { 1 }
    association :user
  end
end
