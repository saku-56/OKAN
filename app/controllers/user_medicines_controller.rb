class UserMedicinesController < ApplicationController
  before_action :set_user_medicine, only: %i[ show edit update destroy ]

  # GET /user_medicines or /user_medicines.json
  def index
    @user_medicines = UserMedicine.all
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
    @user_medicine = UserMedicine.new(user_medicine_params)

    respond_to do |format|
      if @user_medicine.save
        format.html { redirect_to @user_medicine, notice: "User medicine was successfully created." }
        format.json { render :show, status: :created, location: @user_medicine }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_medicine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_medicines/1 or /user_medicines/1.json
  def update
    respond_to do |format|
      if @user_medicine.update(user_medicine_params)
        format.html { redirect_to @user_medicine, notice: "User medicine was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user_medicine }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_medicine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_medicines/1 or /user_medicines/1.json
  def destroy
    @user_medicine.destroy!

    respond_to do |format|
      format.html { redirect_to user_medicines_path, notice: "User medicine was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_medicine
      @user_medicine = UserMedicine.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_medicine_params
      params.require(:user_medicine).permit(:medicine_name, :dosage_per_time, :prescribed_amount, :current_stock, :date_of_prescription, :user_id)
    end
end
