require "rails_helper"

RSpec.describe UserMedicineForm, type: :model do
  let(:user) { create(:user) }

  describe "バリデーション" do
    it "全ての値が正しい場合、validになること" do
      form = UserMedicineForm.new(
        user: user,
        medicine_name: "新しい薬",
        dosage_per_time: 1,
        times_per_day: 2,
        prescribed_amount: 30,
        date_of_prescription: Date.current,
      )
      expect(form).to be_valid
    end

    it "medicine_nameがない場合、invalidになること" do
      form = UserMedicineForm.new(
        user: user,
        medicine_name: nil,
        dosage_per_time: 1,
        times_per_day: 2,
        prescribed_amount: 30,
        date_of_prescription: Date.current,
      )
      expect(form).to be_invalid
      expect(form.errors[:medicine_name]).to be_present
    end
  end

  describe "薬の新規登録" do
    context "新しい薬名の場合" do
      it "MedicineとUserMedicineが作成されること" do
        form = UserMedicineForm.new(
          user: user,
          medicine_name: "新しい薬",
          dosage_per_time: 1,
          times_per_day: 2,
          prescribed_amount: 30,
          date_of_prescription: Date.current,
        )
        expect { form.save }.to change(Medicine, :count).by(1).and change(UserMedicine, :count).by(1)
      end
    end

    context "既存の薬名の場合" do
      let!(:existing_medicine) { create(:medicine, user: user, name: "既存の薬") }

      it "Medicineは作成されず、UserMedicineのみ作成されること" do
        form = UserMedicineForm.new(
          user: user,
          medicine_name: "既存の薬",
          dosage_per_time: 1,
          times_per_day: 2,
          prescribed_amount: 30,
          date_of_prescription: Date.current,
        )
        expect { form.save }.to change(Medicine, :count).by(0).and change(UserMedicine, :count).by(1)
      end
    end
  end
end
