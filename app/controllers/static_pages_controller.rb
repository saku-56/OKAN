class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :top ]
  def top
    if user_signed_in?
      redirect_to user_medicines_path
    end
  end
end
