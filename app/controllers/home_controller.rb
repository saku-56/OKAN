class HomeController < ApplicationController
  def index
    @medicines_with_stock = current_user.user_medicines.with_current_stock
    @date = params[:date]&.to_date
  end
end
