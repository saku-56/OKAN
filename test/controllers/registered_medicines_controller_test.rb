require "test_helper"

class RegisteredMedicinesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get registered_medicines_index_url
    assert_response :success
  end

  test "should get show" do
    get registered_medicines_show_url
    assert_response :success
  end

  test "should get new" do
    get registered_medicines_new_url
    assert_response :success
  end

  test "should get edit" do
    get registered_medicines_edit_url
    assert_response :success
  end
end
