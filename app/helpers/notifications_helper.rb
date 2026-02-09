module NotificationsHelper
  def days_before_options
    (0..7).map { |i| [ i == 0 ? "当日" : "#{i}日前", i ] }
  end
end
