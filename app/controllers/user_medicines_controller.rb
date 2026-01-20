class UserMedicinesController < ApplicationController
  def index
    @user_medicine = current_user.user_medicines
  end

  def autocomplete
    query = params[:query]

    # 自分が過去に入力した薬名のみを取得
    suggestions = current_user.medicines
                               .where("name LIKE ?", "#{query}%")
                               .distinct
                               .pluck(:name)
                               .first(10)
    # 配列をJSON形式に変換してブラウザに返す
    render json: suggestions
  end

  def show
    @user_medicine = current_user.user_medicines.find_by(uuid: params[:id])
  end

  def new
    @form = UserMedicineForm.new
  end

  def create
    @form = UserMedicineForm.new(
      user_medicine_form_params.merge(user: current_user)
    )

    if @form.save
      redirect_to user_medicines_path, notice: "薬を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def add_stock
    @user_medicine = current_user.user_medicines.find_by(uuid: params[:id])
  end

  def update_stock
    @user_medicine = current_user.user_medicines.find_by(uuid: params[:id])

    # 元の在庫量を保存
    original_stock = @user_medicine.current_stock

    # フォームから送信された値をモデルに代入(空で入力するとバリデーションエラーに引っ掛けるため)
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

  def destroy
    @user_medicine = current_user.user_medicines.find_by(uuid: params[:id])
    @user_medicine.destroy
    redirect_to user_medicines_path, notice: "薬を削除しました。"
  end

  private

  def user_medicine_form_params
    params.require(:user_medicine_form).permit(
      :medicine_name,
      :dosage_per_time,
      :prescribed_amount,
      :date_of_prescription
    )
  end

  def user_medicine_params
    params.require(:user_medicine).permit(
      :prescribed_amount,
      :date_of_prescription
    )
  end
end
