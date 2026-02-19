require "rails_helper"

RSpec.describe "ナビゲーションバー", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit root_path
  end

  describe "ナビゲーションバーの表示" do
    it "ナビゲーションバーが表示されること" do
      expect(page).to have_css("nav.fixed.bottom-0")
    end

    it "ナビゲーションバーに各リンクが表示されること" do
      within("nav.fixed.bottom-0") do
        expect(page).to have_link "ホーム"
        expect(page).to have_link "薬一覧"
        expect(page).to have_link "病院一覧"
        expect(page).to have_link "マイページ"
      end
    end
  end

  describe "ナビゲーションバーのリンク遷移" do
    it "ホームリンクをクリックするとホームページに遷移すること" do
      within("nav.fixed.bottom-0") do
        click_on "ホーム"
      end
      expect(page).to have_current_path(home_path)
    end

    it "薬一覧リンクをクリックすると薬一覧ページに遷移すること" do
      within("nav.fixed.bottom-0") do
        click_on "薬一覧"
      end
      expect(page).to have_current_path(user_medicines_path)
    end

    it "病院一覧リンクをクリックすると病院一覧ページに遷移すること" do
      within("nav.fixed.bottom-0") do
        click_on "病院一覧"
      end
      expect(page).to have_current_path(hospitals_path)
    end

    it "マイページリンクをクリックするとマイページに遷移すること" do
      within("nav.fixed.bottom-0") do
        click_on "マイページ"
      end
      expect(page).to have_current_path(mypage_path)
    end
  end
end
