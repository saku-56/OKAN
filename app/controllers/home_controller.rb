class HomeController < ApplicationController
  def index
    @medicines_with_stock = current_user.user_medicines.has_stock.order(created_at: :asc)
    @date = params[:date]&.to_date
    # 通院予定をハッシュで日付ごとに整理
    @consultation_schedules_by_date = current_user.consultation_schedules
                                                .includes(:hospital)
                                                .where("visit_date >= ? AND visit_date <= ?",
                                                       Date.current,
                                                       Date.current + 6.months)
                                                .group_by { |schedule| schedule.visit_date.to_date }
  end
end
