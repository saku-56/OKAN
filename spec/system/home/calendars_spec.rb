require 'rails_helper'

RSpec.describe 'カレンダー表示', type: :system do
  describe 'カレンダー機能', js: true do  # js: trueを忘れずに!
  let(:user) { create(:user) }
  let!(:medicine1) { create(:medicine, name: 'テスト薬A', user: user) }
  let!(:medicine2) { create(:medicine, name: 'テスト薬B', user: user) }

    before do
      login_as(user)
      visit home_path
    end

    context 'モーダルの表示と操作' do
      before do
        create(:user_medicine, medicine: medicine1, current_stock: 5, user: user)
        create(:user_medicine, medicine: medicine2, current_stock: 0, user: user)
      end

      it '今日の日付をクリックするとモーダルが表示される' do
        click_link href: home_path(date: Date.today)

        expect(page).to have_content('2026-01-22 の在庫予定')
        expect(page).to have_content('テスト薬A：残り5錠')
      end

      it 'モーダルの閉じるボタンで元のページに戻る' do
        click_link href: home_path(date: Date.today)

        click_link '閉じる'

        expect(current_path).to eq(home_path)
      end
    end
  end
end
