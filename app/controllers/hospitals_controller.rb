class HospitalsController < ApplicationController
  def index
    @hospital = current_user.hospitals
  end

  def show
    @hospital = current_user.hospitals.includes(:hospital_schedules).find_by(uuid: params[:id])
    @next_visit = @hospital.consultation_schedules.upcoming.first
  end

  def new
    @hospital = current_user.hospitals.build

   # 全曜日×全時間帯の組み合わせを事前に作成
   HospitalSchedule.day_of_weeks.keys.each do |day|
      HospitalSchedule.periods.keys.each do |period|
        @hospital.hospital_schedules.build(
          day_of_week: day,
          period: period
        )
      end
    end
  end

  def create
    @hospital = current_user.hospitals.build(hospital_params)

    if @hospital.save
      redirect_to hospitals_path, notice: "病院を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @hospital = current_user.hospitals.includes(:hospital_schedules).find_by(uuid: params[:id])
  end

  def update
    @hospital = current_user.hospitals.includes(:hospital_schedules).find_by(uuid: params[:id])
    if @hospital.update(hospital_params)
      redirect_to @hospital, notice: "病院情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hospital = current_user.hospitals.find_by(uuid: params[:id])
    @hospital.destroy
    redirect_to hospitals_path, notice: "病院情報を削除しました。"
  end

  private

  def hospital_params
    params.require(:hospital).permit(
      :name,
      :description,
      hospital_schedules_attributes: [
        :id,
        :day_of_week,
        :period,
        :start_time,
        :end_time
      ]
    )
  end
end
