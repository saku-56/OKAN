require "rails_helper"

RSpec.describe "ナビゲーションバー", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit root_path
  end

  describe "ナビゲーションバーの表示" do
    it "ナビゲーションバーが表示されること" do
      expect(page).to have_css(".navigation-section")
    end

    it "ナビゲーションバーに各リンクが表示されること" do
      within(".navigation-section") do
        expect(page).to have_link "ホーム"
        expect(page).to have_link "薬一覧"
        expect(page).to have_link "病院一覧"
        expect(page).to have_content("マイページ")
      end
    end
  end

  describe "ナビゲーションバーのリンク遷移" do
    context "ホーム" do
      it "リンクをクリックするとホームページに遷移すること" do
        within(".navigation-section") do
          click_on "ホーム"
        end
        expect(page).to have_current_path(home_path)
      end
    end

    context "薬一覧" do
      it "リンクをクリックすると薬一覧ページに遷移すること" do
        within(".navigation-section") do
          click_on "薬一覧"
        end
        expect(page).to have_current_path(user_medicines_path)
      end
    end

    context "病院一覧" do
      it "リンクをクリックすると病院一覧ページに遷移すること" do
        within(".navigation-section") do
          click_on "病院一覧"
        end
        expect(page).to have_current_path(hospitals_path)
      end
    end

    context "マイページ" do
      before do
        within(".navigation-section") do
          find(".mypage", text: "マイページ").click
        end
      end

      it "リンクをクリックするとモーダルが表示されること" do
        expect(page).to have_content("アカウント設定")
        expect(page).to have_content("LINE通知設定")
        expect(page).to have_content("ログアウト")
      end

      it "アカウント設定をクリックするとアカウント設定ページに遷移すること" do
        click_on "アカウント設定"

        expect(page).to have_current_path(edit_user_registration_path)
      end

      it "ログアウトをクリックするとログアウトできる" do
        within(".mypage_modal") do
          accept_confirm do
            click_on "ログアウト"
          end
        end
        expect(page).to have_current_path(root_path)
      end

      context "LINE通知設定リンク" do
        context "LINE連携済みの場合" do
          let(:user) { create(:user, :with_line) }

          it "LINE通知設定編集ページに遷移すること" do
            within(".mypage_modal") do
              click_on "LINE通知設定"
            end
            expect(page).to have_current_path(edit_notifications_path)
          end
        end

        context "LINE未連携の場合" do
          let(:user) { create(:user) }

          it "LINE連携ページに遷移すること" do
            within(".mypage_modal") do
              click_on "LINE通知設定"
            end
            expect(page).to have_current_path(notifications_path)
          end
        end
      end
    end
  end
end
