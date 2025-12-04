require "test_helper"

class UserMedicinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_medicine = user_medicines(:one)
  end

  test "should get index" do
    get user_medicines_url
    assert_response :success
  end

  test "should get new" do
    get new_user_medicine_url
    assert_response :success
  end

  test "should create user_medicine" do
    assert_difference("UserMedicine.count") do
      post user_medicines_url, params: { user_medicine: { current_stock: @user_medicine.current_stock, date_of_prescription: @user_medicine.date_of_prescription, dosage_per_time: @user_medicine.dosage_per_time, medicine_name: @user_medicine.medicine_name, prescribed_amount: @user_medicine.prescribed_amount, user_id: @user_medicine.user_id } }
    end

    assert_redirected_to user_medicine_url(UserMedicine.last)
  end

  test "should show user_medicine" do
    get user_medicine_url(@user_medicine)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_medicine_url(@user_medicine)
    assert_response :success
  end

  test "should update user_medicine" do
    patch user_medicine_url(@user_medicine), params: { user_medicine: { current_stock: @user_medicine.current_stock, date_of_prescription: @user_medicine.date_of_prescription, dosage_per_time: @user_medicine.dosage_per_time, medicine_name: @user_medicine.medicine_name, prescribed_amount: @user_medicine.prescribed_amount, user_id: @user_medicine.user_id } }
    assert_redirected_to user_medicine_url(@user_medicine)
  end

  test "should destroy user_medicine" do
    assert_difference("UserMedicine.count", -1) do
      delete user_medicine_url(@user_medicine)
    end

    assert_redirected_to user_medicines_url
  end
end
