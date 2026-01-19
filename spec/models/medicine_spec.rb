require 'rails_helper'

RSpec.describe Medicine, type: :model do
  describe 'バリデーションチェック' do
     let(:user) { create(:user) }

    it '設定したすべてのバリデーションが機能しているか' do
      medicine = build(:medicine, user: user)
      expect(medicine).to be_valid
      expect(medicine.errors).to be_empty
    end

    describe 'name' do
      it 'nameがない場合にバリデーションが機能してinvalidになるか' do
        medicine = build(:medicine, user: user, name: nil)
        expect(medicine).to be_invalid
        expect(medicine.errors[:name]).to include('を入力してください')
      end

      it 'nameが空文字の場合にバリデーションが機能してinvalidになるか' do
        medicine = build(:medicine, user: user, name: '')
        expect(medicine).to be_invalid
        expect(medicine.errors[:name]).to include('を入力してください')
      end
    end
  end
end
