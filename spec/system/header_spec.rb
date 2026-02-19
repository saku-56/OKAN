require "rails_helper"

RSpec.describe "ヘッダーとフッターのナビゲーション", type: :system do
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
        # ハンバーガーメニューを開く（実際のクラス名やIDに合わせて調整してください）
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
        expect(page).to have_link "お問合せ"
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

      it "ログアウトリンクをクリックするとログアウトできること" do
        # 確認ダイアログを自動的に承認する
        accept_confirm do
          click_on "ログアウト"
        end
        # ログアウト後の遷移先に合わせて調整してください
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
          click_on "LINE通知設定"
          expect(page).to have_current_path(edit_notifications_path)
        end
      end

      context "LINE未連携の場合" do
        let(:user) { create(:user) }

        it "LINE連携ページに遷移すること" do
          click_on "LINE通知設定"
          expect(page).to have_current_path(line_connections_path)
        end
      end
    end
  end
end
