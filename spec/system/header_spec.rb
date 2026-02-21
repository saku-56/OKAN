require "rails_helper"

RSpec.describe "ヘッダー", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit home_path
  end

  describe "ヘッダー" do
    context "OKANロゴ" do
      it "クリックするとホームページに遷移すること" do
        click_on "OKAN"
        expect(page).to have_current_path(home_path)
      end
    end

    context "ハンバーガーメニュー" do
      before do
        find(".drawer-button").click
      end

      it "メニューが表示されること" do
        expect(page).to have_link "薬一覧"
        expect(page).to have_link "病院一覧"
        expect(page).to have_link "LINE通知設定"
        expect(page).to have_link "アカウント"
        expect(page).to have_link "使い方"
        expect(page).to have_link "利用規約"
        expect(page).to have_link "プライバシーポリシー"
        expect(page).to have_link "お問い合わせ"
        expect(page).to have_link "ログアウト"
      end

      it "薬一覧リンクをクリックすると薬一覧ページに遷移すること" do
        click_on "薬一覧"
        expect(page).to have_current_path(user_medicines_path)
      end

      it "病院一覧リンクをクリックすると病院一覧ページに遷移すること" do
        click_on "病院一覧"
        expect(page).to have_current_path(hospitals_path)
      end

      it "アカウントリンクをクリックするとアカウント編集ページに遷移すること" do
        click_on "アカウント"
        expect(page).to have_current_path(edit_user_registration_path)
      end

      # it "使い方リンクをクリックすると使い方ページに遷移すること" do
      #   click_on "使い方"
      #   expect(page).to have_current_path(_path)
      # end

      it "利用規約リンクをクリックすると利用規約ページに遷移すること" do
        within(".drawer-side") do
          click_on "利用規約"
        end
        expect(page).to have_current_path(terms_of_service_path)
      end

      it "プライバシーポリシーリンクをクリックするとプライバシーポリシーページに遷移すること" do
        within(".drawer-side") do
          click_on "プライバシーポリシー"
        end
        expect(page).to have_current_path(privacy_path)
      end

      it "お問い合わせリンクをクリックするとお問い合わせページに遷移すること" do
        within("footer") do
          expect(page).to have_link(
          "お問い合わせ",
          href: "https://docs.google.com/forms/d/e/1FAIpQLSfDG16MSVZUjgetz9KKfY7MROubS1F45IzY4MUAFmP2WE5WNA/viewform?usp=header"
          )
        end
      end

      it "ログアウトリンクをクリックするとログアウトできること" do
        accept_confirm do
          click_on "ログアウト"
        end
        expect(page).to have_current_path(root_path)
      end
    end

    context "LINE通知設定リンク" do
      before do
        find(".drawer-button").click
      end

      context "LINE連携済みの場合" do
        let(:user) { create(:user, :with_line) }

        it "LINE通知設定編集ページに遷移すること" do
          within(".drawer-side") do
            click_on "LINE通知設定"
          end
          expect(page).to have_current_path(edit_notifications_path)
        end
      end

      context "LINE未連携の場合" do
        let(:user) { create(:user) }

        it "LINE連携ページに遷移すること" do
          within(".drawer-side") do
            click_on "LINE通知設定"
          end
          expect(page).to have_current_path(notifications_path)
        end
      end
    end
  end
end
