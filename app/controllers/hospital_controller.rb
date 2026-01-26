class HospitalController < ApplicationController
  def index
    @hospital = current_user.hospitals
  end
end
