FactoryBot.define do
  factory :hospital do
    association :user
    sequence(:name) { |n| "病院#{n}" }
    sequence(:description) { |n| "メモ#{n}" }
    uuid { SecureRandom.uuid }
  end
end
