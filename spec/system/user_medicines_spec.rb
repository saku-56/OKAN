require "rails_helper"

RSpec.describe "UserMedicines", type: :system do
  let(:user) { create(:user) }
  let(:medicine) { create(:medicine) }
  let(:user_medicine) { create(:user_medicine) }

  describe "ログイン前" do
    context "薬一覧ページへのアクセス" do
      it "ログインページにリダイレクトされる" do
        visit user_medicines_path
        expect(page).to have_content "ログインしてください"
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe "ログイン後" do
    before do
      sign_in user
    end

    describe "薬の一覧表示" do
      context "薬が登録されていない場合" do
        it "「現在、薬はありません」というメッセージが表示される" do
          visit user_medicines_path
          expect(page).to have_content "現在、薬はありません"
        end
      end

      context "薬が登録されている場合" do
        let!(:medicine) { create(:medicine, name: "テスト薬A") }
        let!(:user_medicine) do
          create(:user_medicine,
                 user: user,
                 medicine: medicine,
                 dosage_per_time: 1)
        end

        it "登録した薬が表示される" do
          visit user_medicines_path
          expect(page).to have_content "テスト薬A"
          expect(page).to have_content "1回の服薬量：1錠"
          expect(page).to have_content "選択"
        end
      end
    end

    describe "薬の新規登録" do
      context "フォームの入力値が正常" do
        it "薬の新規作成が成功する" do
          visit new_user_medicine_path
          fill_in "薬名", with: "新しい薬"
          fill_in "1回の服薬量", with: "1"
          fill_in "1日の服薬回数", with: "2"
          fill_in "処方量", with: "30"
          fill_in "処方日", with: Date.current
          click_button "薬を追加"
          expect(page).to have_content "薬を登録しました"
          expect(current_path).to eq user_medicines_path
          expect(page).to have_content "新しい薬"
        end
      end
    end

    describe "薬の在庫追加" do
      let!(:medicine) { create(:medicine) }
      let!(:user_medicine) { create(:user_medicine, user: user, medicine: medicine, current_stock: 5, dosage_per_time: 1) }
      context "フォームの入力値が正常" do
        it "薬の在庫追加が成功する" do
          visit add_stock_user_medicine_path(user_medicine)
          fill_in "処方量", with: "30"
          fill_in "処方日", with: Date.current
          click_button "在庫を追加する"
          expect(page).to have_content "薬を追加しました"
          expect(current_path).to eq user_medicines_path
        end
      end
    end

    describe "薬の詳細表示" do
      let(:user_medicine) { create(:user_medicine, user: user) }
      before do
        user_medicine
        visit user_medicine_path(user_medicine)
      end

      it "登録した全ての項目が表示されること" do
        expect(page).to have_content(user_medicine.medicine.name)
        expect(page).to have_content(user_medicine.dosage_per_time)
        expect(page).to have_content(user_medicine.times_per_day)
        expect(page).to have_content(user_medicine.prescribed_amount)
        expect(page).to have_content(user_medicine.date_of_prescription)
      end
    end

    describe "薬の飲み忘れ調整機能" do
      before do
        visit user_medicine_path(user_medicine)
      end
      context "飲み忘れボタンの表示" do
        context "在庫がある場合" do
          let(:user_medicine) { create(:user_medicine, user: user, medicine: medicine, current_stock: 10, dosage_per_time: 2) }
          it "飲み忘れボタンが表示される" do
            expect(page).to have_button("飲み忘れ"), "在庫がある場合、飲み忘れボタンが表示されていません"
          end
        end

        context "在庫がない場合" do
          let(:user_medicine) { create(:user_medicine, user: user, medicine: medicine, current_stock: 0, dosage_per_time: 2) }
          it "飲み忘れボタンが表示されない" do
            expect(page).not_to have_button("飲み忘れ"), "在庫がない場合、飲み忘れボタンが表示されています"
          end
        end
      end

      context "飲み忘れボタンを押した場合" do
        let(:user_medicine) { create(:user_medicine, user: user, medicine: medicine, current_stock: 10, dosage_per_time: 2) }
        before do
          visit user_medicine_path(user_medicine)
        end

        it "確認ダイアログが表示され、はいを押すと在庫量が1回の服薬量分増える" do
          accept_confirm do
            click_button "飲み忘れ"
          end

          expect(page).to have_content("在庫を1回分増やしました"), "フラッシュメッセージが表示されていません"
          expect(page).to have_content("現在の在庫")
          expect(page).to have_content("12 錠"), "在庫量の表示が正しく増えていません（期待値: 12 錠）"
          expect(user_medicine.reload.current_stock).to eq(12), "データベースの在庫量が正しく更新されていません（期待値: 12錠）"
        end

        it "確認ダイアログでいいえを押すと在庫量が変わらない" do
          dismiss_confirm do
            click_button "飲み忘れ"
          end

          expect(page).to have_content("現在の在庫")
          expect(page).to have_content("10 錠"), "在庫量の表示が変わってしまっています（期待値: 10 錠）"
          expect(user_medicine.reload.current_stock).to eq(10), "データベースの在庫量が変わってしまっています（期待値: 10錠）"
        end
      end
    end

    describe "薬の削除" do
      let(:user_medicine) { create(:user_medicine, user: user) }
      before do
        user_medicine
        visit user_medicine_path(user_medicine)
      end

      it "薬が削除できること" do
        expect(page).to have_css(".delete-icon")

        page.accept_confirm do
          find(".delete-icon").click
        end
        expect(page).to have_content("薬を削除しました"), "フラッシュメッセージが表示されていません"
        expect(current_path).to eq user_medicines_path
      end
    end
  end
end
