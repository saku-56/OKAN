require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      it 'ログイン処理が成功する' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content ('ログインしました。')
        expect(current_path).to eq home_path
      end
    end
  end
  describe 'ログイン後' do
    before do
      login_as(user)
      # 画面サイズを広げる
      page.driver.browser.manage.window.resize_to(1200, 1000)
    end

    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do
        visit edit_user_registration_path

        accept_confirm do
          click_link 'ログアウト'
        end

        expect(page).to have_content('ログアウトしました。')
        expect(current_path).to eq root_path
      end
    end
  end
end
