module HospitalHelper
  def time_range(hospital, day, period)
    schedule = hospital.hospital_schedules.find do |s|
      s.day_of_week == day.to_s && s.period == period.to_s
    end

    return "—" unless schedule&.start_time && schedule&.end_time

    "#{schedule.start_time.strftime('%-H:%M')}–#{schedule.end_time.strftime('%-H:%M')}"
  end
end
