require "rails_helper"

RSpec.describe Hospital, type: :model do
  let(:user) { create(:user) }

  describe "バリデーションチェック" do
    it "設定したすべてのバリデーションが機能しているか" do
      hospital = build(:hospital, user: user)
      expect(hospital).to be_valid
      expect(hospital.errors).to be_empty
    end
  end

  describe "name" do
    it "nameがない場合にバリデーションが機能してinvalidになるか" do
      hospital = build(:hospital, user: user, name: nil)
      expect(hospital).to be_invalid
      expect(hospital.errors[:name]).to include("を入力してください")
    end

    it "nameが20文字を超える場合にバリデーションが機能してinvalidになるか" do
      hospital = build(:hospital, user: user, name: "あ" * 21)
      expect(hospital).to be_invalid
      expect(hospital.errors[:name]).to include("は20文字以内で入力してください")
    end
  end

  describe "description" do
    it "descriptionが100文字を超える場合にバリデーションが機能してinvalidになるか" do
      hospital = build(:hospital, user: user, description: "あ" * 101)
      expect(hospital).to be_invalid
      expect(hospital.errors[:description]).to include("は100文字以内で入力してください")
    end
  end

  describe "uuid" do
    it "uuidが重複した場合にバリデーションが機能してinvalidになるか" do
      uuid = SecureRandom.uuid
      create(:hospital, user: user, uuid: uuid)
      hospital = build(:hospital, user: user, uuid: uuid)
      expect(hospital).to be_invalid
      expect(hospital.errors[:uuid]).to include("はすでに存在します")
    end
  end

  describe "accepts_nested_attributes_for" do
    it "hospital_schedulesのネストした属性を受け付ける" do
      hospital = Hospital.new(
        name: "テスト病院",
        user: user,
        hospital_schedules_attributes: [
          { day_of_week: :monday, period: :morning, start_time: "09:00", end_time: "12:00" }
        ],
      )
      expect(hospital.save).to be true
      expect(hospital.hospital_schedules.count).to eq 1
    end
  end

  describe "アソシエーション" do
    it "userに属していること" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it "hospital_schedulesと関連していること" do
      association = described_class.reflect_on_association(:hospital_schedules)
      expect(association.macro).to eq :has_many
    end

    it "hospital_schedulesがdependent: :destroyであること" do
      association = described_class.reflect_on_association(:hospital_schedules)
      expect(association.options[:dependent]).to eq :destroy
    end
  end
end
