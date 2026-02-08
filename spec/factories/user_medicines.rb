FactoryBot.define do
  factory :user_medicine do
    dosage_per_time { 1 }
    times_per_day { 2 }
    prescribed_amount { 30 }
    date_of_prescription { Date.current }
    sequence(:uuid) { SecureRandom.uuid }
    association :user
    association :medicine
  end
end
