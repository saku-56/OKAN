class UserMedicinesController < ApplicationController
  def index
    @user_medicines = current_user.user_medicines.where("current_stock > 0").order(date_of_prescription: :desc)
  end

  # 薬選択画面
  def select_medicine
    @medicines = Medicine.all
  end

  def new
    @user_medicine = current_user.user_medicines.build

    # 薬が選択されている場合
    if params[:medicine_id].present?
      @selected_medicine = Medicine.find(params[:medicine_id])
      @user_medicine.medicine = @selected_medicine
    end
    # 選択されていない場合は空のフォーム
  end

  def create
    @user_medicine = current_user.user_medicines.build(user_medicine_params)

    # 既存の薬を選択した場合
    if params[:user_medicine][:medicine_id].present?
      @user_medicine.medicine_id = params[:user_medicine][:medicine_id]

    # 新規に薬を登録する場合
    elsif params[:user_medicine][:new_medicine_name].present?
      medicine = Medicine.find_or_create_by(
        name: params[:user_medicine][:new_medicine_name]
      ) do |m|
        m.dosage_per_intake = params[:user_medicine][:new_medicine_dosage]
      end
      @user_medicine.medicine = medicine

    else
      flash.now[:error] = "薬を選択するか、新しい薬の情報を入力してください"
      render :new, status: :unprocessable_entity
      return
    end

    if @user_medicine.save
      redirect_to user_medicines_path, notice: "服薬情報を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  def user_medicine_params
    params.require(:user_medicine).permit(
      :prescribed_amount,
      :start_date,
      :current_stock
    )
  end
end
