# require "application_system_test_case"

# class UserMedicinesTest < ApplicationSystemTestCase
#   setup do
#     @user_medicine = user_medicines(:one)
#   end

#   test "visiting the index" do
#     sign_in users(:one)
#     visit registered_medicines_path
#     assert_selector "h1", text: "User medicines"
#   end

#   test "should create user medicine" do
#     sign_in users(:one)
#     visit new_registered_medicine_path
#     click_on "登録する"

#     fill_in "Current stock", with: @user_medicine.current_stock
#     fill_in "Date of prescription", with: @user_medicine.date_of_prescription
#     fill_in "Dosage per time", with: @user_medicine.dosage_per_time
#     fill_in "Medicine name", with: @user_medicine.medicine_name
#     fill_in "Prescribed amount", with: @user_medicine.prescribed_amount
#     fill_in "User", with: @user_medicine.user_id
#     click_on "Create User medicine"

#     assert_text "User medicine was successfully created"
#     click_on "Back"
#   end

#   test "should update User medicine" do
#     sign_in users(:one)
#     visit registered_medicine_path(@user_medicine)
#     click_on "Edit this user medicine", match: :first

#     fill_in "Current stock", with: @user_medicine.current_stock
#     fill_in "Date of prescription", with: @user_medicine.date_of_prescription
#     fill_in "Dosage per time", with: @user_medicine.dosage_per_time
#     fill_in "Medicine name", with: @user_medicine.medicine_name
#     fill_in "Prescribed amount", with: @user_medicine.prescribed_amount
#     fill_in "User", with: @user_medicine.user_id
#     click_on "Update User medicine"

#     assert_text "User medicine was successfully updated"
#     click_on "Back"
#   end

#   test "should destroy User medicine" do
#     sign_in users(:one)
#     visit registered_medicine_path(@user_medicine)
#     accept_confirm { click_on "Destroy this user medicine", match: :first }

#     assert_text "User medicine was successfully destroyed"
#   end
# end
