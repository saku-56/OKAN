class MedicinesController < ApplicationController
  before_action :set_medicine, only: %i[ show edit update destroy ]

  # いつもの薬一覧
  def index
   @medicines = current_user.medicines.page(params[:page]).per(8)
  end

  def show
  end

  def new
    @medicine = Medicine.new
  end

  # GET /user_medicines/1/edit
  def edit
  end

  # POST /user_medicines or /user_medicines.json
  def create
    @medicine = current_user.medicines.build(medicine_params)
      if @medicine.save
        redirect_to medicines_path, notice: "薬を登録しました"
      else
        render :new, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /user_medicines/1 or /user_medicines/1.json
  def update
    if @medicine.update(medicine_params)
      redirect_to medicines_path(@medicine), notice: "薬情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medicine.destroy!
    redirect_to medicines_path, notice: "薬を削除しました"
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
