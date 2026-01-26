module HospitalHelper
  def time_select_15min(form, field, start_hour, end_hour)
    select_tag(
      "#{form.object_name}[#{field}]",
      options_for_select(
        time_options(start_hour, end_hour),
        form.object.send(field)&.strftime("%H:%M")
      ),
      include_blank: true,
      class: "w-full px-1 py-1 text-xs border border-gray-300 rounded focus:ring-1 focus:ring-blue-500"
    )
  end

  def time_options(start_hour, end_hour)
    (start_hour...end_hour).flat_map do |hour|
      [ 0, 15, 30, 45 ].map do |min|
        time = format("%02d:%02d", hour, min)
        [ time, time ]
      end
    end
  end
end
