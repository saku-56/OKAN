class LeftoverMedicinesController < ApplicationController
  def index
    @leftover_medicines = current_user.user_medicines.where("current_stock > 0").order(date_of_prescription: :desc)
  end
end
