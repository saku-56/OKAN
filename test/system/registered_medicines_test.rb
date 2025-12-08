require "application_system_test_case"

class RegisteredMedicinesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    sign_in @user
    @user_medicine = user_medicines(:one)
  end

  #   test "お薬一覧ページを表示する" do
  #     visit registered_medicines_path
  #     assert_selector "h1", text: "お薬一覧"
  #   end

  test "登録薬を新規登録する" do
    visit new_registered_medicine_path
    fill_in "薬名", with: "新しい薬"
    fill_in "一回の服薬量", with: "1"
    fill_in "処方量", with: "30"
    fill_in "服薬開始日", with: Date.today.to_s
    click_button "この内容で追加"
    assert_text "薬を登録しました"
  end

  #   test "お薬を編集する" do
  #     visit edit_registered_medicine_path(@user_medicine)
  #     fill_in "薬の名前", with: "更新された薬"
  #     click_button "更新"
  #     assert_text "お薬を更新しました"
  #     assert_text "更新された薬"
  #   end

  #   test "お薬を削除する" do
  #     visit registered_medicines_path
  #     accept_confirm do
  #       click_link "削除", match: :first
  #     end
  #     assert_text "お薬を削除しました"
  #   end
end
