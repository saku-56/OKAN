require 'rails_helper'

RSpec.describe ConsultationSchedule, type: :model do
  let(:user) { create(:user) }
  let(:hospital) { create(:hospital) }

  describe "バリデーションチェック" do
    it "設定したすべてのバリデーションが機能しているか" do
      consultation_schedule = build(:consultation_schedule, user: user)
      expect(consultation_schedule).to be_valid
      expect(consultation_schedule.errors).to be_empty
    end

    describe "visit_date" do
      it "visit_dateがない場合にバリデーションが機能してinvalidになるか" do
        consultation_schedule = build(:consultation_schedule, user: user, visit_date: nil)
        expect(consultation_schedule).to be_invalid
        expect(consultation_schedule.errors[:visit_date]).to include("を入力してください")
      end

      it "visit_dateが過去の場合にカスタムバリデーションが機能してinvalidになるか" do
        consultation_schedule = build(:consultation_schedule, user: user, visit_date: Date.yesterday)
        expect(consultation_schedule).to be_invalid
        expect(consultation_schedule.errors[:visit_date]).to be_present
      end

      it "visit_dateが6ヶ月先以降の場合にカスタムバリデーションが機能してinvalidになるか" do
        consultation_schedule = build(:consultation_schedule, user: user, visit_date: 7.months.from_now.to_date)
        expect(consultation_schedule).to be_invalid
        expect(consultation_schedule.errors[:visit_date]).to be_present
      end
    end
  end

  describe "アソシエーション" do
    it "userに属していること" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "hospitalに属していること" do
      association = described_class.reflect_on_association(:hospital)
      expect(association.macro).to eq :belongs_to
    end
  end
end
