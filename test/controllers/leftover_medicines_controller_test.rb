require "test_helper"

class LeftoverMedicinesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get leftover_medicines_index_url
    assert_response :success
  end
end
