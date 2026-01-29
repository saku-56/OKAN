require "rails_helper"

RSpec.describe "UserEditRegistrations", type: :system do
  let(:user) { create(:user, name: "元の名前", email: "original@example.com", password: "password") }

  before do
    login_as(user)
  end

  describe "ユーザー情報編集" do
    before do
      visit edit_user_registration_path
    end

    context "正常系" do
      it "名前が変更できる" do
        fill_in "名前", with: "新しい名前"
        fill_in "現在のパスワード", with: "password"
        click_button "変更する"

        expect(page).to have_content("アカウント情報を変更しました。")
        expect(page).to have_field("名前", with: "新しい名前")
      end

      it "メールアドレスが変更できる" do
        fill_in "メールアドレス", with: "new@example.com"
        fill_in "現在のパスワード", with: "password"
        click_button "変更する"

        expect(page).to have_content("アカウント情報を変更しました。")
        expect(user.reload.email).to eq "new@example.com"
      end

      # it 'パスワードが変更できる' do
      #   fill_in 'パスワード', with: 'newpassword'
      #   fill_in 'パスワード確認', with: 'newpassword'
      #   fill_in '現在のパスワード', with: 'password'
      #   click_button '変更する'

      #   expect(page).to have_content('アカウント情報を変更しました。', wait: 10)

      # 新しいパスワードでログインできるか確認
      #   click_link 'ログアウト'

      #   visit sign_in_path
      #   fill_in 'メールアドレス', with: user.email
      #   fill_in 'パスワード', with: 'newpassword'
      #   click_on 'ログイン'

      #   expect(page).to have_content('ログインしました')
      # end
    end

    context "異常系" do
      it "現在のパスワードを入力しないと変更できない" do
        fill_in "名前", with: "新しい名前"
        fill_in "現在のパスワード", with: ""
        click_button "変更する"

        expect(page).to have_content("現在のパスワードを入力してください")
      end

      it "現在のパスワードが間違っていると変更できない" do
        fill_in "名前", with: "新しい名前"
        fill_in "現在のパスワード", with: "wrongpassword"
        click_button "変更する"

        expect(page).to have_content("現在のパスワードは不正な値です")
      end
    end
  end

  describe "アカウント削除" do
    before do
      visit edit_user_registration_path
    end

    it "アカウント削除が成功する", js: true do
      # 確認ダイアログを自動的にOKにする
      accept_confirm do
        click_link "アカウント削除"
      end

      expect(page).to have_content("アカウントを削除しました。またのご利用をお待ちしております。")
      expect(current_path).to eq root_path
    end

    it "削除されたユーザーでログインできない" do
      deleted_email = user.email
      deleted_password = "password"

      accept_confirm do
        click_link "アカウント削除"
      end

      # 削除されたユーザーでログインを試みる
      visit new_user_session_path
      fill_in "メールアドレス", with: deleted_email
      fill_in "パスワード", with: deleted_password
      click_on "ログイン"

      expect(page).to have_content("メールアドレス もしくはパスワードが不正です。")
      expect(current_path).to eq new_user_session_path
    end
  end
end
