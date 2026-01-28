require "rails_helper"

RSpec.describe HospitalSchedule, type: :model do
  let(:hospital) { create(:hospital) }

  describe "バリデーションチェック" do
    it "設定したすべてのバリデーションが機能しているか" do
      hospital_schedule = build(:hospital_schedule, hospital: hospital)
      expect(hospital_schedule).to be_valid
      expect(hospital_schedule.errors).to be_empty
    end
  end

  describe "day_of_week" do
    it "day_of_weekがない場合にバリデーションが機能してinvalidになるか" do
      hospital_schedule = build(:hospital_schedule, hospital: hospital, day_of_week: nil)
      expect(hospital_schedule).to be_invalid
    end
  end

  describe "period" do
    it "periodがない場合にバリデーションが機能してinvalidになるか" do
      hospital_schedule = build(:hospital_schedule, hospital: hospital, period: nil)
      expect(hospital_schedule).to be_invalid
    end
  end

  describe "時間のバリデーション" do
    it "開始時間のみ入力された場合にバリデーションが機能してinvalidになるか" do
      hospital_schedule = build(:hospital_schedule, hospital: hospital, start_time: "09:00", end_time: nil)
      expect(hospital_schedule).to be_invalid
      expect(hospital_schedule.errors[:end_time]).to include("を入力してください")
    end

    it "終了時間のみ入力された場合にバリデーションが機能してinvalidになるか" do
      hospital_schedule = build(:hospital_schedule, hospital: hospital, start_time: nil, end_time: "12:00")
      expect(hospital_schedule).to be_invalid
      expect(hospital_schedule.errors[:start_time]).to include("を入力してください")
    end

    it "開始時間が終了時間より後の場合にバリデーションが機能してinvalidになるか" do
      hospital_schedule = build(:hospital_schedule, hospital: hospital, start_time: "12:00", end_time: "09:00")
      expect(hospital_schedule).to be_invalid
      expect(hospital_schedule.errors[:end_time]).to include("は開始時間より遅い時刻に設定してください")
    end

    it "開始時間と終了時間が正しい場合にバリデーションが通るか" do
      hospital_schedule = build(:hospital_schedule, hospital: hospital, start_time: "09:00", end_time: "12:00")
      expect(hospital_schedule).to be_valid
      expect(hospital_schedule.errors).to be_empty
    end

    it "両方の時間が未入力の場合にバリデーションが通るか" do
      hospital_schedule = build(:hospital_schedule, hospital: hospital, start_time: nil, end_time: nil)
      expect(hospital_schedule).to be_valid
      expect(hospital_schedule.errors).to be_empty
    end
  end

  describe "時間文字列のパース" do
    it "文字列の時間をTime型に変換する" do
      hospital_schedule = create(:hospital_schedule, hospital: hospital, start_time: "09:00", end_time: "12:00")

      expect(hospital_schedule.start_time).to be_a(Time)
      expect(hospital_schedule.end_time).to be_a(Time)
      expect(hospital_schedule.start_time.hour).to eq 9
      expect(hospital_schedule.start_time.min).to eq 0
      expect(hospital_schedule.end_time.hour).to eq 12
      expect(hospital_schedule.end_time.min).to eq 0
    end
  end

  describe "アソシエーション" do
    it "hospitalに属していること" do
      association = described_class.reflect_on_association(:hospital)
      expect(association.macro).to eq :belongs_to
    end
  end
end
