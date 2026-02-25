require "rails_helper"

RSpec.describe "今日の在庫一覧", type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
  end

  describe "今日の在庫一覧" do
    let!(:medicine1) { create(:medicine, name: "テスト薬A", user: user) }
    let!(:medicine2) { create(:medicine, name: "テスト薬B", user: user) }

    context "在庫のある薬がない場合" do
      before do
        create(:user_medicine, medicine: medicine1, current_stock: 0, user: user)
        create(:user_medicine, medicine: medicine2, current_stock: 0, user: user)
        visit home_path
      end

      it "服薬中の薬はありませんと表示される" do
        expect(page).to have_content("服薬中の薬はありません。")
      end
    end

    context "在庫がある薬とない薬が混在している場合" do
      before do
        create(:user_medicine, medicine: medicine1, current_stock: 5, user: user)
        create(:user_medicine, medicine: medicine2, current_stock: 0, user: user)
        visit home_path
      end

      it "在庫がある薬だけが表示される" do
        expect(page).to have_content("テスト薬A")
        expect(page).to have_content("5錠")
      end
    end
  end
end
