FactoryBot.define do
  factory :consultation_schedule do
    visit_date { Date.current }
    association :user
    association :hospital
  end
end
