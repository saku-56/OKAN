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

  describe 'ログイン後' do
    before do
      sign_in user
    end

    describe '薬の一覧表示' do
      context '薬が登録されていない場合' do
        it '「現在、薬はありません」というメッセージが表示される' do
          visit user_medicines_path
          expect(page).to have_content '現在、薬はありません'
        end
      end

      context '薬が登録されている場合' do
        let!(:user_medicine) { create(:user_medicine, user: user, medicine_name: 'aaa', current_stock: 5, dosage_per_time: 1) }

        it '登録した薬が表示される' do
          visit user_medicines_path
          expect(page).to have_content 'aaa'
          expect(page).to have_content '1回の服薬量：1錠'
          expect(page).to have_content '詳細'
        end
      end
    end

    describe '薬選択画面表示' do
      context '登録が登録されている場合' do
        let!(:user_medicine) { create(:user_medicine, user: user, medicine_name: 'aaa', current_stock: 5, dosage_per_time: 1) }

        it '登録した薬が表示される' do
          visit select_medicine_user_medicines_path
          expect(page).to have_content 'aaa'
          expect(page).to have_content '1回の服薬量：1錠'
          expect(page).to have_content '選択'
          expect(page).to have_content '新規登録'
        end

        it '選択ボタンを押すと薬名、1回の服薬量、現在の在庫が表示されている' do
          visit add_stock_user_medicine_path(user_medicine)
          expect(page).to have_content 'aaa'
          expect(page).to have_content '1 錠'
          expect(page).to have_content '5 錠'
        end
      end
    end

    describe '薬の新規登録' do
      context 'フォームの入力値が正常' do
        it '薬の新規作成が成功する' do
          visit new_user_medicine_path
          fill_in '薬名', with: 'aaa'
          fill_in '1回の服薬量', with: '1'
          fill_in '処方量', with: '30'
          fill_in '処方日', with: Date.current
          click_button '薬を追加'
          expect(page).to have_content '薬を登録しました'
          expect(current_path).to eq user_medicines_path
        end
      end
    end

    describe '薬の在庫追加' do
      let!(:user_medicine) { create(:user_medicine, user: user, medicine_name: '風邪薬', current_stock: 5, dosage_per_time: 1) }
      context 'フォームの入力値が正常' do
        it '薬の在庫追加が成功する' do
          visit add_stock_user_medicine_path(user_medicine)
          fill_in '処方量', with: '30'
          fill_in '処方日', with: Date.current
          click_button '在庫を追加'
          expect(page).to have_content '薬を追加しました'
          expect(current_path).to eq user_medicines_path
        end
      end
    end

    describe '薬の詳細表示' do
      let(:user_medicine) { create(:user_medicine, user: user) }
      before do
        user_medicine
        visit user_medicine_path(user_medicine)
      end

      it '登録した全ての項目が表示されること' do
        expect(page).to have_content(user_medicine.medicine_name)
        expect(page).to have_content(user_medicine.dosage_per_time)
        expect(page).to have_content(user_medicine.prescribed_amount)
        expect(page).to have_content(user_medicine.date_of_prescription)
      end
    end
  end
end
