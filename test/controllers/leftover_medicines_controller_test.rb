require "test_helper"

class LeftoverMedicinesControllerTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers
  test "should get index" do
    sign_in users(:one)
    get leftover_medicines_url
    assert_response :success
  end
end
