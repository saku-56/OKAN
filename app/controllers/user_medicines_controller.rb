class UserMedicinesController < ApplicationController
  def index
    @medicines_with_stock = current_user.user_medicines.with_current_stock
    @date = params[:date]&.to_date
  end

  # 薬選択画面
  def select_medicine
    @medicines_with_stock = current_user.user_medicines.with_current_stock
  end

  def new
    @user_medicine = UserMedicine.new
  end

  def create
    @user_medicine = current_user.user_medicines.build(user_medicine_params)
    @user_medicine.current_stock = @user_medicine.initial_stock_on_create

      if @user_medicine.save
        redirect_to user_medicines_path, notice: "薬を登録しました"
      else
        render :new, status: :unprocessable_entity
      end
  end

  def add_stock
    @user_medicine = current_user.user_medicines.find(params[:id])
  end

  def update_stock
    @user_medicine = current_user.user_medicines.find(params[:id])

    # 元の在庫量を保存
    original_stock = @user_medicine.current_stock

    # フォームから送信された値をモデルに代入
    @user_medicine.assign_attributes(user_medicine_params)

    # バリデーションチェック
    if @user_medicine.valid?
      # フォームに入力した処方量を在庫量に加算
      @user_medicine.current_stock = original_stock + @user_medicine.prescribed_amount

      @user_medicine.save
      redirect_to user_medicines_path, notice: "薬を追加しました"
    else
      render :add_stock, status: :unprocessable_entity
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
