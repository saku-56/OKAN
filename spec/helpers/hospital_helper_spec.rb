require "rails_helper"

RSpec.describe HospitalHelper, type: :helper do
  describe "#time_range" do
    let(:hospital) { create(:hospital) }

    context "診療時間が登録されている場合" do
      let!(:schedule) do
        create(:hospital_schedule,
               hospital: hospital,
               day_of_week: :monday,
               period: :morning,
               start_time: "09:00",
               end_time: "12:00")
      end

      it "時間範囲が正しく表示されること" do
        result = helper.time_range(hospital, :monday, :morning)
        expect(result).to eq "9:00 - 12:00"
      end
    end

    context "診療時間が登録されていない場合" do
      it "「ー」が表示されること" do
        result = helper.time_range(hospital, :monday, :morning)
        expect(result).to eq "ー"
      end
    end
  end

  describe "#time_options" do
    it "午前の正しい時間選択肢が生成されること" do
      options = helper.morning_time_options

      # 6時から23時45分まで、15分刻みで選択肢が72個
      expect(options.length).to eq 72

      # 最初の要素を確認
      expect(options.first).to eq [ "06:00", "06:00" ]

      # 最後の要素を確認
      expect(options.last).to eq [ "23:45", "23:45" ]

      # 特定の時間が含まれているか確認
      expect(options).to include([ "09:00", "09:00" ])
      expect(options).to include([ "12:30", "12:30" ])
      expect(options).to include([ "18:15", "18:15" ])
    end

    it "午後の正しい時間選択肢が生成されること" do
      options = helper.afternoon_time_options

      # 10時から23時45分まで、15分刻みで選択肢が72個
      expect(options.length).to eq 56

      # 最初の要素を確認
      expect(options.first).to eq [ "10:00", "10:00" ]

      # 最後の要素を確認
      expect(options.last).to eq [ "23:45", "23:45" ]

      # 特定の時間が含まれているか確認
      expect(options).to include([ "10:00", "10:00" ])
      expect(options).to include([ "12:30", "12:30" ])
      expect(options).to include([ "18:15", "18:15" ])
    end

    it "15分刻みで生成されること" do
      options = helper.morning_time_options

      expect(options).to include([ "09:00", "09:00" ])
      expect(options).to include([ "09:15", "09:15" ])
      expect(options).to include([ "09:30", "09:30" ])
      expect(options).to include([ "09:45", "09:45" ])
    end

    it "存在しない時間が含まれていないこと" do
      options = helper.afternoon_time_options

      expect(options).not_to include([ "05:00", "05:00" ])
      expect(options).not_to include([ "09:00", "09:00" ])
      expect(options).not_to include([ "24:00", "24:00" ])
      expect(options).not_to include([ "10:10", "10:10" ])
    end
  end
end
