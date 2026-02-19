require "rails_helper"

RSpec.describe "フッター", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit root_path
  end

  describe "フッターリンクの表示" do
    it "フッターに各リンクが表示されること" do
      within("footer") do
        expect(page).to have_link "利用規約"
        expect(page).to have_link "プライバシーポリシー"
        expect(page).to have_link "お問い合わせ"
      end
    end
  end

  describe "フッターリンクの遷移" do
    it "利用規約リンクをクリックすると利用規約ページに遷移すること" do
      within("footer") do
        click_on "利用規約"
      end
      expect(page).to have_current_path(terms_of_service_path)
    end

    it "プライバシーポリシーリンクをクリックするとプライバシーポリシーページに遷移すること" do
      within("footer") do
        click_on "プライバシーポリシー"
      end
      expect(page).to have_current_path(privacy_path)
    end

    # it "お問い合わせリンクをクリックするとお問い合わせページに遷移すること" do
    #   within("footer") do
    #     click_on "お問い合わせ"
    #   end
    #   expect(page).to have_current_path(contact_path)
    # end
  end
end
