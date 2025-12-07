require "test_helper"

class RegisteredMedicinesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:one)
    get registered_medicines_url
    assert_response :success
  end

  test "should get show" do
    sign_in users(:one)
    user_medicine = user_medicines(:one)
    get registered_medicine_url(user_medicine)
    assert_response :success
  end

  test "should get new" do
    sign_in users(:one)
    get new_registered_medicine_url
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:one)
    user_medicine = user_medicines(:one)
    get edit_registered_medicine_url(user_medicine)
    assert_response :success
  end
end
