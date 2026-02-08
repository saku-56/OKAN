require "rails_helper"

RSpec.describe "カレンダー表示", type: :system do
  describe "カレンダー機能" do
    let(:user) { create(:user) }
    let!(:medicine1) { create(:medicine, name: "テスト薬A", user: user) }
    let!(:medicine2) { create(:medicine, name: "テスト薬B", user: user) }
    let!(:hospital) { create(:hospital, user: user, name: "病院A") }

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

    context "カレンダー上の表示" do
      before do
        create(:user_medicine, medicine: medicine2, prescribed_amount: 2, date_of_prescription: Date.yesterday, dosage_per_time: 1, times_per_day: 1, current_stock: 1, user: user)
        create(:consultation_schedule, user: user, hospital: hospital, visit_date: Date.current)
        page.driver.browser.manage.window.resize_to(1200, 1000)
        visit home_path
      end
      it "在庫切れ表示がある" do
        expect(page).to have_content("テスト薬B 在庫切れ予定")
      end

      it "通院予定の表示がある" do
        expect(page).to have_content("病院A通院予定")
      end
    end

    describe "前月ボタンの動作" do
      current_month = Time.current.strftime("%Y年%m月")
      previous_month = 1.month.ago.strftime("%Y年%m月")

      context "1ヶ月前に遷移する場合" do
        it "正常に前月のカレンダーが表示される" do
          # 現在の月が表示されていることを確認
          expect(page).to have_content(current_month)

          # 前月ボタンをクリック
          click_link "前月"

          # 前月のカレンダーが表示されることを確認
          expect(page).to have_content(previous_month)
        end
      end

      context "1ヶ月以上前に遷移しようとする場合" do
        it "ブラウザのアラートが表示される" do
          # まず1ヶ月前に遷移
          click_link "前月"

          # 次のクリックでアラートが表示される
          accept_alert "1ヶ月以上前は表示できません" do
            click_button "前月"
          end

          # ページが遷移していないことを確認（1ヶ月のまま）
          expect(page).to have_content(previous_month)
        end
      end
    end

    describe "次月ボタンの動作" do
      context "6ヶ月先まで遷移する場合" do
        it "正常に次月のカレンダーが表示される" do
          6.times do |i|
            target_month = (i + 1).months.from_now.strftime("%Y年%m月")

            # 次月ボタンをクリック
            click_link "次月"

            # 対象月のカレンダーが表示されることを確認
            expect(page).to have_content(target_month)
          end
        end
      end

      context "6ヶ月より先に遷移しようとする場合" do
        it "ブラウザのアラートが表示される" do
          # 6ヶ月先まで遷移
          6.times { click_link "次月" }

          # 7回目のクリックでアラートが表示される
          accept_alert "6ヶ月先以降は表示できません" do
            # ボタンのテキストで指定（テキスト内の矢印も含める）
            click_button "次月"
          end

          # ページが遷移していないことを確認（6ヶ月先のまま）
          expect(page).to have_content(6.months.from_now.strftime("%Y年%m月"))
        end
      end
    end
  end
end
