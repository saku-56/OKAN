require "rails_helper"

RSpec.describe "カレンダー表示", type: :system do
  describe "カレンダー機能" do
    let(:user) { create(:user) }
    let!(:medicine1) { create(:medicine, name: "テスト薬A", user: user) }
    let!(:medicine2) { create(:medicine, name: "テスト薬B", user: user) }

    before do
      login_as(user)
      visit home_path
    end

    context "モーダルの表示" do
      it "薬がない場合、この日は在庫がありませんと表示される" do
        click_link href: home_path(date: Date.today)

        expect(page).to have_content("この日は在庫がありません。")
      end

      it "モーダルの閉じるボタンで元のページに戻る" do
        click_link href: home_path(date: Date.today)

        click_link "閉じる"

        expect(current_path).to eq(home_path)
      end
    end

    context "モーダルの挙動" do
      before do
        create(:user_medicine, medicine: medicine1, dosage_per_time: 1, current_stock: 1, user: user)
      end
      context "今日の日付をクリックすると" do
        it "今日の在庫が表示される" do
          click_link href: home_path(date: Date.today)

          expect(page).to have_content("#{Date.today} の在庫予定")
          expect(page).to have_content("テスト薬A：残り1錠")
        end
      end

      context "過去の日付をクリックすると" do
        it "今日より前の日付の在庫は表示できません。と表示される" do
          click_link href: home_path(date: Date.yesterday)

          expect(page).to have_content("#{Date.yesterday} の在庫予定")
          expect(page).to have_content("今日より前の日付の在庫は表示できません")
        end
      end

      context "未来の日付をクリックすると" do
        it "クリックした日の在予想庫が表示される" do
          click_link href: home_path(date: Date.tomorrow)

          expect(page).to have_content("#{Date.tomorrow} の在庫予定")
          expect(page).to have_content("テスト薬A：残り0錠")
        end
      end
    end

    context "カレンダー上の警告表示" do
      before do
        create(:user_medicine, medicine: medicine2, prescribed_amount: 12, date_of_prescription: Date.yesterday, dosage_per_time: 1, current_stock: 11, user: user)
        page.driver.browser.manage.window.resize_to(1200, 1000)
        visit home_path
      end
      it "残り10錠の表示がある" do
        expect(page).to have_content("テスト薬B10錠")
      end
    end
  end
end
