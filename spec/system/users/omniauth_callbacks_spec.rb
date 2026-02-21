require "rails_helper"

RSpec.describe "Users::OmniauthCallbacks", type: :system do
  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe "LINEログイン機能" do
    context "新規ユーザーの場合" do
      it "LINEで新規登録できる" do
        line_mock

        visit new_user_registration_path
        click_button "LINEでログイン"

        expect(page).to have_content "LINE アカウントでログインしました"
        expect(current_path).to eq home_path
        expect(User.last.line_user_id).to eq "12345"
      end
    end

    context "新規登録済みのLINEユーザーの場合" do
      let!(:user) { create(:user, :line_login) }

      it "登録済みのアカウントでログインできる" do
        line_mock

        visit new_user_session_path

        click_button "LINEでログイン"

        expect(page).to have_content "LINE アカウントでログインしました"
        expect(current_path).to eq home_path
      end
    end

    context "LINE認証に失敗した場合" do
      it "エラーメッセージが表示される" do
        line_mock_failure

        visit new_user_registration_path
        click_button "LINEでログイン"

        expect(page).to have_content "LINE認証に失敗しました"
        expect(current_path).to eq root_path
      end
    end
  end

  describe "LINE連携機能" do
    let!(:user) { create(:user) }

    before do
      sign_in user
    end

    context "LINEログイン以外でログインしたユーザーがLINE連携する場合" do
      it "LINE連携が成功する" do
        line_mock

        visit notifications_path
        click_button "LINEと連携する"

        expect(page).to have_content "LINE連携が完了しました"
        expect(current_path).to eq edit_notifications_path
        expect(user.reload.line_user_id).to eq "12345"
      end
    end

    context "既に他のユーザーが使用しているLINEアカウントの場合" do
      let!(:other_user) { create(:user, :with_line, line_user_id: "12345") }

      it "エラーメッセージが表示される" do
        line_mock

        visit notifications_path
        click_button "LINEと連携する"

        expect(page).to have_content "このLINEアカウントは既に他のユーザーに連携されています"
        expect(current_path).to eq home_path
        expect(user.reload.line_user_id).to be_nil
      end
    end
  end

  describe "Googleログイン機能" do
    context "新規ユーザーの場合" do
      it "Googleで新規登録できる" do
        line_mock

        visit new_user_registration_path
        click_button "Googleログイン"

        expect(page).to have_content "Google アカウントでログインしました"
        expect(current_path).to eq home_path
      end
    end

    context "登録済みのGoogleユーザーの場合" do
      let!(:user) { create(:user, :line_login) }

      it "登録済みのアカウントでログインできる" do
        line_mock

        visit new_user_session_path

        click_button "Googleログイン"

        expect(page).to have_content "Google アカウントでログインしました"
        expect(current_path).to eq home_path
      end
    end

    context "Google認証に失敗した場合" do
      it "エラーメッセージが表示される" do
        google_mock_failure

        visit new_user_registration_path
        click_button "Googleログイン"

        expect(page).to have_content "Google認証に失敗しました"
        expect(current_path).to eq root_path
      end
    end
  end
end
