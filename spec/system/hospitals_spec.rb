require "rails_helper"

RSpec.describe "Hospitals", type: :system do
  let(:user) { create(:user) }

  describe "ログイン前" do
    context "病院情報一覧ページへのアクセス" do
      it "ログインページにリダイレクトされる" do
        visit hospitals_path
        expect(page).to have_content "ログインしてください"
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe "ログイン後" do
    before do
      sign_in user
    end

    describe "病院の一覧表示" do
      context "病院が登録されていない場合" do
        it "登録した病院が存在しない場合、メッセージが表示されること" do
          visit hospitals_path
          expect(page).to have_content "現在、病院情報はありません"
        end
      end

      context "病院情報が登録されている場合" do
        let!(:hospital) { create(:hospital, user: user) }

        it "登録した病院の一覧が表示されること" do
          visit hospitals_path

          expect(page).to have_content(hospital.name)
        end
      end
    end

    describe "病院情報の新規作成" do
      it "病院情報を登録できること" do
        visit new_hospital_path

        # 基本情報の入力
        fill_in "病院名", with: "クリニックA"
        fill_in "メモ", with: "予約優先です。"

        # 月曜日の午前の時間を入力
        select "09:00", from: "hospital[hospital_schedules_attributes][0][start_time]"
        select "12:00", from: "hospital[hospital_schedules_attributes][0][end_time]"

        # 月曜日の午後の時間を入力
        select "14:00", from: "hospital[hospital_schedules_attributes][1][start_time]"
        select "18:00", from: "hospital[hospital_schedules_attributes][1][end_time]"

        # 火曜日の午前の時間を入力
        select "09:00", from: "hospital[hospital_schedules_attributes][2][start_time]"
        select "12:00", from: "hospital[hospital_schedules_attributes][2][end_time]"

        click_button "登録"

        # 登録成功の確認
        expect(page).to have_content "病院を登録しました"
        expect(page).to have_content "クリニックA"

        # データベースの確認
        hospital = Hospital.last
        expect(hospital.name).to eq "クリニックA"
        expect(hospital.description).to eq "予約優先です。"
        expect(hospital.user).to eq user

        # 16個のスケジュールが作成されていることを確認
        hospital = Hospital.last
        expect(hospital.hospital_schedules.count).to eq 16

        # スケジュールの確認
        monday_morning = hospital.hospital_schedules.find_by(day_of_week: :monday, period: :morning)
        expect(monday_morning).to be_present
        expect(monday_morning.start_time.strftime("%H:%M")).to eq "09:00"
        expect(monday_morning.end_time.strftime("%H:%M")).to eq "12:00"

        monday_afternoon = hospital.hospital_schedules.find_by(day_of_week: :monday, period: :afternoon)
        expect(monday_afternoon).to be_present
        expect(monday_afternoon.start_time.strftime("%H:%M")).to eq "14:00"
        expect(monday_afternoon.end_time.strftime("%H:%M")).to eq "18:00"
      end

      it "病院名が空の場合はバリデーションエラーが表示されること" do
        visit new_hospital_path

        # 病院名を入力せずに診療時間だけ入力
        select "09:00", from: "hospital[hospital_schedules_attributes][0][start_time]"
        select "12:00", from: "hospital[hospital_schedules_attributes][0][end_time]"

        click_button "登録"

        # エラーメッセージの確認
        expect(page).to have_content "病院名を入力してください"
        expect(Hospital.count).to eq 0
      end

      it "開始時間が終了時間より後の場合はバリデーションエラーが表示されること" do
        visit new_hospital_path

        fill_in "病院名", with: "テスト病院"

        # 開始時間を終了時間より後に設定
        select "12:00", from: "hospital[hospital_schedules_attributes][0][start_time]"
        select "09:00", from: "hospital[hospital_schedules_attributes][0][end_time]"

        click_button "登録"

        # エラーメッセージの確認
        expect(page).to have_content "終了時間は開始時間より遅い時刻に設定してください"
        expect(Hospital.count).to eq 0
      end
    end

    describe "病院の詳細表示" do
      let!(:hospital) { create(:hospital, user: user) }

      # 複数の診療時間を作成
      let!(:monday_morning) { create(:hospital_schedule, :monday, :morning, start_time: "09:00", end_time: "12:00", hospital: hospital) }
      let!(:monday_afternoon) { create(:hospital_schedule, :monday, :afternoon, start_time: "14:00", end_time: "18:00", hospital: hospital) }
      let!(:tuesday_morning) { create(:hospital_schedule, :tuesday, :morning, start_time: "10:00", end_time: "13:00", hospital: hospital) }
      # 休診の例(時間がnil)
      let!(:wednesday_morning) { create(:hospital_schedule, :wednesday, :morning, start_time: nil, end_time: nil, hospital: hospital) }

      before do
        visit hospital_path(hospital)
      end

      it "登録した全ての項目が表示されること" do
        expect(page).to have_content(hospital.name)
        expect(page).to have_content(hospital.description)
        expect(page).to have_content("月")
        expect(page).to have_content("9:00 - 12:00")
        expect(page).to have_content("14:00 - 18:00")
        expect(page).to have_content("火")
        expect(page).to have_content("10:00 - 13:00")
      end

      it "休診日は適切に表示されること" do
        expect(page).to have_content("ー")
      end

      it "診療時間が表形式で表示されること" do
        # tableタグの存在確認
        expect(page).to have_selector("table")

        # ヘッダーの確認(曜日、午前、午後)
        within "table thead" do
          expect(page).to have_content("曜日")
          expect(page).to have_content("午前")
          expect(page).to have_content("午後")
        end

        # 曜日の表示
        within "table tbody" do
          expect(page).to have_content("月")
          expect(page).to have_content("火")
          expect(page).to have_content("水")
          expect(page).to have_content("木")
          expect(page).to have_content("金")
          expect(page).to have_content("土")
          expect(page).to have_content("日")
          expect(page).to have_content("祝")
        end
      end
    end

    describe "病院情報の削除" do
      let!(:hospital) { create(:hospital, user: user) }
      let!(:hospital_schedule) { create(:hospital_schedule, hospital: hospital) }

      before do
        visit hospital_path(hospital)
      end

      it "病院情報が削除できること" do
        expect(page).to have_link "削除"
        page.accept_confirm { click_link "削除" }
        expect(page).to have_content("病院情報を削除しました。"), "フラッシュメッセージが表示されていません"
        expect(current_path).to eq hospitals_path
      end
    end

    describe "病院情報の編集" do
      let!(:hospital) { create(:hospital, user: user) }


      describe "病院基本情報の更新" do
        it "病院名を更新できること" do
          visit edit_hospital_path(hospital)

          fill_in "病院名", with: "新しい病院名"
          click_button "変更"

          expect(page).to have_content "病院情報を更新しました"
          expect(page).to have_content "新しい病院名"
        end

        it "メモを更新できること" do
          visit edit_hospital_path(hospital)

          fill_in "メモ", with: "新しいメモ内容"
          click_button "変更"

          expect(page).to have_content "病院情報を更新しました"
          expect(page).to have_content "新しいメモ内容"
        end
      end

      describe "診療スケジュールの更新" do
        it "既存のスケジュールを更新できること" do
          create(:hospital_schedule, start_time: "09:00", end_time: "12:00", hospital: hospital)
          visit edit_hospital_path(hospital)

          # 月曜日の午前を14:00-18:00に変更
          select "10:00", from: "hospital_hospital_schedules_attributes_1_start_time"
          select "13:00", from: "hospital_hospital_schedules_attributes_1_end_time"

          click_button "変更"

          sleep 5
          expect(current_path).to eq hospital_path(hospital)
          expect(page).to have_content "病院情報を更新しました"
          # expect(page).to have_content("10:00 - 13:00")
        end
      end
    end
  end
end
