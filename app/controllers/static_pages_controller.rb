class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[top]

  def top
    if user_signed_in?
      redirect_to home_path
    end
  end

  def terms_of_service
  end
end
