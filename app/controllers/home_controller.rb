class HomeController < ApplicationController
  def index
    @medicines_with_stock = current_user.user_medicines.has_stock.order(created_at: :asc)
    @date = params[:date]&.to_date
  end
end
