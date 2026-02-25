class HomeController < ApplicationController
  def index
    @medicines_with_stock = current_user.user_medicines.includes(:medicine).has_stock.order(created_at: :desc)
    @date = params[:date]&.to_date

    # URLで直接日付を指定された時用
    requested_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.current

    # 1ヶ月前〜6ヶ月先まで表示可能
    min_date = Date.current.beginning_of_month - 1.month
    max_date = Date.current.beginning_of_month + 6.months

    @start_date = if requested_date < min_date
      min_date
    elsif requested_date > max_date
      max_date
    else
      requested_date.beginning_of_month
    end

    # 来月の1週目にある予定を今月に表示する用
    calendar_start = @start_date.beginning_of_week
    calendar_end = @start_date.end_of_month.end_of_week

    # 今日以降のみ取得
    schedule_start = [ Date.current, calendar_start ].max
    # ハッシュで日付ごとに整理
    @consultation_schedules_by_date = current_user.consultation_schedules
                                                  .includes(:hospital)
                                                  .where(visit_date: schedule_start..calendar_end)
                                                  .group_by { |schedule| schedule.visit_date.to_date }

    # モーダル表示用（特定の日付の通院予定）
    if @date
      @selected_schedules = @consultation_schedules_by_date[@date] || []
    end
  end
end
