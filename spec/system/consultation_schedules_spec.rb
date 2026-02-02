require "rails_helper"

RSpec.describe "ConsultationSchedules", type: :system do
  let(:user) { create(:user) }
  let(:hospital) { create(:hospital, user: user) }

  before do
    sign_in user
  end

  describe "通院予定の表示" do
    context "通院予定がない場合" do
      it "フォームが空欄で表示される" do
        visit hospital_path(hospital)

        expect(page).to have_field("consultation_schedule[visit_date]", with: "")
      end
    end

    context "通院予定がある場合（statusがscheduledでvisit_dateが未来）" do
      let(:future_date) { 5.days.from_now.to_date }

      before do
        create(:consultation_schedule, user: user, hospital: hospital, status: :scheduled, visit_date: future_date)
      end

      it "フォームに通院予定日が表示される" do
        visit hospital_path(hospital)

        expect(page).to have_field("consultation_schedule[visit_date]", with: future_date.to_s)
      end
    end

    # バッチ処理の失敗などでcompletedに更新されなかった場合を想定
    context "statusがscheduledだがvisit_dateが過去の場合" do
      let(:past_date) { 3.days.ago.to_date }

      before do
        # バリデーションをスキップして過去日付のデータを作成
        consultation_schedule = build(:consultation_schedule,
                                      user: user,
                                      hospital: hospital,
                                      status: :scheduled,
                                      visit_date: past_date)
        consultation_schedule.save(validate: false)
      end

      it "フォームが空欄で表示される" do
        visit hospital_path(hospital)

        expect(page).to have_field("consultation_schedule[visit_date]", with: "")
      end
    end
  end

  describe "通院予定の作成" do
    let(:visit_date) { 7.days.from_now.to_date }

    context "正常な入力の場合" do
      it "通院予定日を登録できる" do
        visit hospital_path(hospital)

        page.accept_confirm do
          fill_in "consultation_schedule[visit_date]", with: visit_date
        end

        expect(page).to have_content "通院予定日を登録しました"
        expect(page).to have_field("consultation_schedule[visit_date]", with: visit_date.to_s)
      end
    end
  end

  describe "通院予定の変更" do
    let(:initial_date) { 5.days.from_now.to_date }
    let(:new_date) { 10.days.from_now.to_date }

    before do
      create(:consultation_schedule, user: user, hospital: hospital, status: :scheduled, visit_date: initial_date)
    end

    context "正常な入力の場合" do
      it "通院予定日を更新できる" do
        visit hospital_path(hospital)

        page.accept_confirm do
          fill_in "consultation_schedule[visit_date]", with: new_date
        end

        expect(page).to have_content "通院予定日を変更しました"
        expect(page).to have_field("consultation_schedule[visit_date]", with: new_date.to_s)
      end
    end
  end

  describe "通院予定の削除" do
    let!(:hospital) { create(:hospital, user: user) }
    let!(:consultation_schedule) { create(:consultation_schedule, hospital: hospital, user: user) }

    before do
      visit hospital_path(hospital)
      page.driver.browser.manage.window.resize_to(1200, 1000)
    end

    it "通院予定が削除できること" do
      page.accept_confirm do
        find('[data-testid="delete-schedule-icon"]').click
      end

      expect(page).to have_content("通院予定を削除しました")
    end
  end
end
