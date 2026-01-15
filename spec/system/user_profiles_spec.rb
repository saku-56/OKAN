require 'rails_helper'

RSpec.describe 'UserProfiles', type: :system do
  let(:user) { create(:user, name: '元の名前', email: 'original@example.com', password: 'password') }
  let(:other_user) { create(:user) }

  before do
    # ログインヘルパーを使用（login_asメソッドがあると仮定）
    login_as(user)
  end

   describe 'ユーザー情報編集' do
    before do
      visit edit_user_registration_path
    end

    context '正常系' do
      it '名前が変更できる' do
        fill_in '名前', with: '新しい名前'
        fill_in '現在のパスワード', with: 'password'
        click_button '変更する'

        expect(page).to have_content('アカウント情報を変更しました。')
        expect(page).to have_field('名前', with: '新しい名前')
      end

      it 'メールアドレスが変更できる' do
        fill_in 'メールアドレス', with: 'new@example.com'
        fill_in '現在のパスワード', with: 'password'
        click_button '変更する'

        expect(page).to have_content('アカウント情報を変更しました。')
        expect(user.reload.email).to eq 'new@example.com'
      end

      it 'パスワードが変更できる' do
        fill_in 'パスワード', with: 'newpassword'
        fill_in 'パスワード確認', with: 'newpassword'
        fill_in '現在のパスワード', with: 'password'
        click_button '変更する'

        expect(current_path).to eq edit_user_registration_path
        expect(page).to have_content('アカウント情報を変更しました。')

        # ログアウトして新しいパスワードでログインできるか確認
        # click_button 'ログアウト' # または適切なログアウト方法
        # visit new_user_session_path
        # fill_in 'メールアドレス', with: user.email
        # fill_in 'パスワード', with: 'newpassword'
        # click_button 'ログイン'

        # expect(page).to have_content('ログインしました')
      end

      it '変更が反映されている' do
        fill_in '名前', with: '変更後の名前'
        fill_in 'メールアドレス', with: 'changed@example.com'
        fill_in '現在のパスワード', with: 'password'
        click_button '変更する'

        user.reload
        expect(page).to have_field('名前', with: '変更後の名前')
        expect(page).to have_field('メールアドレス', with: 'changed@example.com')
      end
    end

    context '異常系' do
      it 'すでに存在するメールアドレスは保存できない' do
        fill_in 'メールアドレス', with: other_user.email
        fill_in '現在のパスワード', with: 'password'
        click_button '変更する'

        expect(page).to have_content('メールアドレスはすでに存在します')
        expect(user.reload.email).to eq 'original@example.com'
      end

      it 'パスワードが6文字未満だと登録できない' do
        fill_in 'パスワード', with: '12345'
        fill_in 'パスワード確認', with: '12345'
        fill_in '現在のパスワード', with: 'password'
        click_button '変更する'

        expect(page).to have_content('パスワードは6文字以上で入力してください')
      end

      it 'パスワード確認とパスワードが一致しないと登録できない' do
        fill_in 'パスワード', with: 'newpassword'
        fill_in 'パスワード確認', with: 'different'
        fill_in '現在のパスワード', with: 'password'
        click_button '変更する'

        expect(page).to have_content('パスワード（確認用）とパスワードの入力が一致しません')
      end

      it '現在のパスワードを入力しないと変更できない' do
        fill_in '名前', with: '新しい名前'
        fill_in '現在のパスワード', with: ''
        click_button '変更する'

        expect(page).to have_content('現在のパスワードを入力してください')
        expect(user.reload.name).to eq '元の名前'
      end

      it '現在のパスワードが間違っていると変更できない' do
        fill_in '名前', with: '新しい名前'
        fill_in '現在のパスワード', with: 'wrongpassword'
        click_button '変更する'

        expect(page).to have_content('現在のパスワードは不正な値です')
        expect(user.reload.name).to eq '元の名前'
      end
    end
  end

  describe 'アカウント削除' do
    before do
        visit edit_user_registration_path
    end

    it 'アカウント削除が成功する', js: true do
        # 確認ダイアログを自動的にOKにする
        accept_confirm do
        click_button 'アカウント削除'
        end

        expect(page).to have_content('アカウントを削除しました。またのご利用をお待ちしております。')
        expect(current_path).to eq root_path
    end

    it '削除されたユーザーでログインできない' do
        deleted_email = user.email
        deleted_password = 'password'

        accept_confirm do
        click_button 'アカウント削除'
        end

        # 削除されたユーザーでログインを試みる
        visit new_user_session_path
        fill_in 'メールアドレス', with: deleted_email
        fill_in 'パスワード', with: deleted_password
        click_on 'ログイン'

        expect(page).to have_content('メールアドレス もしくはパスワードが不正です。')
        expect(current_path).to eq new_user_session_path
    end
  end
end
