require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能しているか' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it 'nameがない場合にバリデーションが機能してinvalidになるか' do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("を入力してください")
    end

    it 'emailがない場合にバリデーションが機能してinvalidになるか' do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to include("を入力してください")
    end

    it 'passwordがない場合にバリデーションが機能してinvalidになるか' do
      user = build(:user, password: nil, password_confirmation: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("を入力してください")
    end

    it 'emailが被った場合にuniqueのバリデーションが機能してinvalidになるか' do
      user1 = create(:user, email: "test@example.com")
      user2 = build(:user, email: "test@example.com")
      expect(user2).to be_invalid
      expect(user2.errors[:email]).to include("はすでに存在します")
    end

    it 'emailが被らない場合はvalidになるか' do
      user1 = create(:user, email: "test1@example.com")
      user2 = build(:user, email: "test2@example.com")
      expect(user2).to be_valid
    end

    it 'uuidが自動生成されること' do
      user = create(:user)
      expect(user.uuid).to be_present
      expect(user.uuid).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)
    end
  end
end
