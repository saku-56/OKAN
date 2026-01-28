FactoryBot.define do
  factory :hospital do
    association :user
    name { '病院A' }
    description { '30分前から受付開始' }
    uuid { SecureRandom.uuid }
  end
end
