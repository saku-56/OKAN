FactoryBot.define do
  factory :user_medicine do
    sequence(:medicine_name) { |n| "薬#{n}" }
    dosage_per_time { 1 }
    prescribed_amount { 30 }
    date_of_prescription { Date.current }
    is_regular { true }
    association :user
  end
end
