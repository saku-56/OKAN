FactoryBot.define do
  factory :hospital_schedule do
    association :hospital
    day_of_week { :monday }
    period { :morning }
    start_time { '09:00' }
    end_time { '12:00' }
  end
end
