class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[top terms_of_service privacy]

  def top
    if user_signed_in?
      redirect_to home_path
    end
  end

  def terms_of_service; end

  def privacy; end
end
