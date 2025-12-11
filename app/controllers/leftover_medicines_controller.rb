class LeftoverMedicinesController < ApplicationController
  def index
    @leftover_medicines = current_user.user_medicines.where("current_stock > 0").order(date_of_prescription: :desc)
  end

  def new
    @user_medicine = current_user.user_medicines.find(params[:user_medicine_id])
  end

  def create
    @user_medicine = current_user.user_medicines.find(params[:user_medicine_id])
    # 処方量をcurrent_stockに加算
    prescribed_amount = params[:prescribed_amount].to_i
    @user_medicine.current_stock += prescribed_amount
    @user_medicine.date_of_prescription = params[:date_of_prescription]
    if @user_medicine.save
      redirect_to leftover_medicines_path, notice: "処方薬を追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end
end
