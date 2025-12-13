class MedicinesController < ApplicationController
  before_action :set_medicine, only: %i[ show edit update destroy ]

  # いつもの薬一覧
  def index
   @medicines = current_user.medicines.page(params[:page]).per(8)
  end

  # 処方箋追加用一覧（選択）
  def select
    @user_medicines = current_user.user_medicines.page(params[:page]).per(8)
  end

  # GET /user_medicines/1 or /user_medicines/1.json
  def show
  end

  # GET /user_medicines/new
  def new
    @user_medicine = UserMedicine.new
  end

  # GET /user_medicines/1/edit
  def edit
  end

  # POST /user_medicines or /user_medicines.json
  def create
    @user_medicine = current_user.user_medicines.build(user_medicine_params)

    # 処方量を在庫として設定(手元に在庫がない初回登録時用)
    @user_medicine.current_stock = @user_medicine.prescribed_amount

      if @user_medicine.save
        redirect_to registered_medicines_path, notice: "薬を登録しました"
      else
        render :new, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /user_medicines/1 or /user_medicines/1.json
  def update
    if @user_medicine.update(user_medicine_params)
      redirect_to registered_medicine_path(@user_medicine), notice: "薬情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user_medicines/1 or /user_medicines/1.json
  def destroy
    @user_medicine.destroy!
    redirect_to registered_medicines_path, notice: "薬を削除しました"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medicine
      @medicine = current_user.medicines.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def medicine_params
      params.require(:medicine).permit(:name, :dosage_per_time)
    end
end
