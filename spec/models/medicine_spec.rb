require "rails_helper"

RSpec.describe Medicine, type: :model do
  describe "バリデーションチェック" do
    let(:user) { create(:user) }

    it "設定したすべてのバリデーションが機能しているか" do
      medicine = build(:medicine, user: user)
      expect(medicine).to be_valid
      expect(medicine.errors).to be_empty
    end

    describe "name" do
      it "nameがない場合にバリデーションが機能してinvalidになるか" do
        medicine = build(:medicine, user: user, name: nil)
        expect(medicine).to be_invalid
        expect(medicine.errors[:name]).to include("を入力してください")
      end

      it "nameが21文字以上の場合にバリデーションが機能してinvalidになるか" do
        medicine = build(:medicine, user: user, name: "a" * 21)
        expect(medicine).to be_invalid
        expect(medicine.errors[:name]).to include("は20文字以内で入力してください")
      end

      it "同じユーザーが同じnameを登録するとバリデーションが機能してinvalidになるか" do
        create(:medicine, user: user, name: "テスト薬A")
        medicine = build(:medicine, user: user, name: "テスト薬A")
        expect(medicine).to be_invalid
        expect(medicine.errors[:name]).to include("はすでに存在します")
      end

      it "異なるユーザーなら同じnameでも登録できるか" do
        user2 = create(:user)
        create(:medicine, user: user, name: "テスト薬A")
        medicine = build(:medicine, user: user2, name: "テスト薬A")
        expect(medicine).to be_valid
      end
    end
  end
end
