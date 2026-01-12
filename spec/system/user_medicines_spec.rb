require 'rails_helper'

RSpec.describe "UserMedicines", type: :system do
  let(:user) { create(:user) }
  let(:user_medicine) { create(:user_medicine) }

  describe 'ログイン前' do
    context '薬一覧ページへのアクセス' do
      it 'ログインページにリダイレクトされる' do
        visit user_medicines_path
        expect(page).to have_content 'ログインしてください'
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
