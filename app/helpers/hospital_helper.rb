module HospitalHelper
   def schedule_symbol(hospital, day, period)
    schedule = hospital.hospital_schedules.find do |s|
      s.day_of_week == day.to_s && s.period == period.to_s
    end

    return "×" unless schedule&.start_time && schedule&.end_time

    # 土曜午前だけなどは △
    if day.to_s == "saturday" && period.to_s == "morning"
      "△"
    else
      "○"
    end
  end
end
