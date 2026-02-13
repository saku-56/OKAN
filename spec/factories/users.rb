FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "ユーザー#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    # LINE連携済みユーザー
    trait :with_line do
      sequence(:line_user_id) { |n| "line_user_id_#{n}" }
    end

    # LINEでログインしたユーザー
    trait :line_login do
      sequence(:line_user_id) { |n| "line_uid_#{n}" }
      email { "#{line_user_id}@line.example.com" }
    end
  end
end
