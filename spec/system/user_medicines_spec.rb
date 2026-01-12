require 'rails_helper'

RSpec.describe "UserMedicines", type: :system do
  let(:user) { create(:user) }
  let(:user_medicine) { create(:user_medicine) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'タスクの新規登録ページにアクセス' do
        it '新規登録ページへのアクセスが失敗する' do
          visit new_task_path
          expect(page).to have_content('Login required')
          expect(current_path).to eq login_path
        end
      end
    end
  end
end
