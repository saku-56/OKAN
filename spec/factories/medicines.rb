FactoryBot.define do
  factory :medicine do
    sequence(:name) { |n| "薬#{n}" }
    association :user
  end
end
