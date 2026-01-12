require "rails_helper"

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it '登録に成功すること' do
          visit new_user_registration_path
          fill_in '名前', with: "山田太郎"
          fill_in 'メールアドレス', with: "example@example.com"
          fill_in 'パスワード', with: "example"
          fill_in 'パスワード確認', with: "example"
          click_button '登録する'
          expect(page).to have_content("アカウント登録が完了しました。")
          expect(current_path).to eq user_medicines_path
        end
      end

      context '異常系' do
        it 'メールアドレスが既に登録されている場合、登録できない' do
          existing_user = create(:user, email: "test@example.com")
          visit new_user_registration_path
          fill_in '名前', with: "山田太郎"
          fill_in 'メールアドレス', with: "test@example.com"
          fill_in 'パスワード', with: "password"
          fill_in 'パスワード確認', with: "password"
          click_button '登録する'
          expect(page).to have_content "メールアドレスはすでに存在します"
          expect(current_path).to eq new_user_registration_path
        end
      end
    end
  end
end
