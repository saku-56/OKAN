class UserMedicinesController < ApplicationController
  def index
    @user_medicines = current_user.user_medicines.where("current_stock > 0").order(date_of_prescription: :desc)
  end

  # 薬選択画面
  def select_medicine
    @medicines = Medicine.all
  end

  def new
    @user_medicine = UserMedicine.new
  end

  def create
    @user_medicine = current_user.user_medicines.build(user_medicine_params)

    # 処方量を在庫として設定(手元に在庫がない初回登録時用)
    @user_medicine.current_stock = @user_medicine.prescribed_amount

      if @user_medicine.save
        redirect_to user_medicines_path, notice: "薬を登録しました"
      else
        render :new, status: :unprocessable_entity
      end
  end

  private

  def user_medicine_params
    params.require(:user_medicine).permit(
      :medicine_name,
      :dosage_per_time,
      :prescribed_amount,
      :date_of_prescription
    )
  end
end
