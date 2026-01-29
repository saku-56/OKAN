FactoryBot.define do
  factory :hospital_schedule do
    association :hospital
    day_of_week { :monday }
    period { :morning }
    start_time { nil }
    end_time { nil }
  end
end
#     # 休診のパターン
#     trait :closed do
#       start_time { nil }
#       end_time { nil }
#     end

#     # 午前のパターン
#     trait :morning do
#       period { :morning }
#       start_time { "09:00" }
#       end_time { "12:00" }
#     end

#     # 午後のパターン
#     trait :afternoon do
#       period { :afternoon }
#       start_time { "14:00" }
#       end_time { "18:00" }
#     end

#     # 各曜日のtrait
#     trait :monday do
#       day_of_week { :monday }
#     end

#     trait :tuesday do
#       day_of_week { :tuesday }
#     end

#     trait :wednesday do
#       day_of_week { :wednesday }
#     end

#     trait :thursday do
#       day_of_week { :thursday }
#     end

#     trait :friday do
#       day_of_week { :friday }
#     end

#     trait :saturday do
#       day_of_week { :saturday }
#     end

#     trait :sunday do
#       day_of_week { :sunday }
#     end

#     trait :holiday do
#       day_of_week { :holiday }
#     end
#   end
# end
