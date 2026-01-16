require 'rails_helper'

RSpec.describe UserMedicine, type: :model do
  describe 'バリデーションチェック' do
    let(:user) { create(:user) }

    it '設定したすべてのバリデーションが機能しているか' do
      user_medicine = build(:user_medicine, user: user)
      expect(user_medicine).to be_valid
      expect(user_medicine.errors).to be_empty
    end

    describe 'medicine_name' do
      it 'medicine_nameがない場合にバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, medicine_name: nil)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:medicine_name]).to include('を入力してください')
      end

      it 'medicine_nameが空文字の場合にバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, medicine_name: '')
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:medicine_name]).to include('を入力してください')
      end
    end

    describe 'dosage_per_time' do
      it 'dosage_per_timeがない場合にバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, dosage_per_time: nil)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:dosage_per_time]).to include('を入力してください')
      end

      it 'dosage_per_timeが整数でない場合にバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, dosage_per_time: 1.5)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:dosage_per_time]).to include('は整数で入力してください')
      end

      it 'dosage_per_timeが0の場合にバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, dosage_per_time: 0)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:dosage_per_time]).to include('は1以上の値にしてください')
      end

      it 'dosage_per_timeが負の数の場合にバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, dosage_per_time: -1)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:dosage_per_time]).to include('は1以上の値にしてください')
      end

      it 'dosage_per_timeが1の場合にvalidになるか' do
        user_medicine = build(:user_medicine, user: user, dosage_per_time: 1)
        expect(user_medicine).to be_valid
      end
    end

    describe 'prescribed_amount' do
      it 'prescribed_amountがない場合にバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, prescribed_amount: nil)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:prescribed_amount]).to include('を入力してください')
      end

      it 'prescribed_amountが整数でない場合にバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, prescribed_amount: 10.5)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:prescribed_amount]).to include('は整数で入力してください')
      end

      it 'prescribed_amountが0の場合にバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, prescribed_amount: 0)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:prescribed_amount]).to include('は1以上の値にしてください')
      end

      it 'prescribed_amountが負の数の場合にバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, prescribed_amount: -10)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:prescribed_amount]).to include('は1以上の値にしてください')
      end

      it 'prescribed_amountが1の場合にvalidになるか' do
        user_medicine = build(:user_medicine, user: user, prescribed_amount: 1)
        expect(user_medicine).to be_valid
      end
    end

    describe 'uuid' do
      it 'uuidが被った場合にuniqueのバリデーションが機能してinvalidになるか' do
        uuid = SecureRandom.uuid
        create(:user_medicine, user: user, uuid: uuid)
        user_medicine = build(:user_medicine, user: user, uuid: uuid)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:uuid]).to include('はすでに存在します')
      end

      it 'uuidが被らない場合はvalidになるか' do
        create(:user_medicine, user: user)
        user_medicine = build(:user_medicine, user: user)
        expect(user_medicine).to be_valid
      end
    end

    describe 'date_of_prescription' do
      it 'date_of_prescriptionがない場合にバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, date_of_prescription: nil)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:date_of_prescription]).to be_present
      end

      it 'date_of_prescriptionが未来日の場合にカスタムバリデーションが機能してinvalidになるか' do
        user_medicine = build(:user_medicine, user: user, date_of_prescription: Date.tomorrow)
        expect(user_medicine).to be_invalid
        expect(user_medicine.errors[:date_of_prescription]).to be_present
      end

      it 'date_of_prescriptionが今日の日付の場合にvalidになるか' do
        user_medicine = build(:user_medicine, user: user, date_of_prescription: Date.today)
        expect(user_medicine).to be_valid
      end

      it 'date_of_prescriptionが過去の日付の場合にvalidになるか' do
        user_medicine = build(:user_medicine, user: user, date_of_prescription: Date.yesterday)
        expect(user_medicine).to be_valid
      end
    end
  end

  describe 'カラムのデフォルト値' do
    let(:user) { create(:user) }

    it 'current_stockのデフォルト値が0であること' do
      user_medicine = UserMedicine.new(user: user)
      expect(user_medicine.current_stock).to eq(0)
    end

    it 'is_regularのデフォルト値がtrueであること' do
      user_medicine = UserMedicine.new(user: user)
      expect(user_medicine.is_regular).to eq(true)
    end

    it 'uuidが自動生成されること' do
      user_medicine = create(:user_medicine, user: user)
      expect(user_medicine.uuid).to be_present
    end
  end

  describe 'アソシエーション' do
    it 'userに属していること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
