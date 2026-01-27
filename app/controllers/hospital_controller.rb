class HospitalController < ApplicationController
  def index
    @hospital = current_user.hospitals
  end

  def show
    @hospital = current_user.hospitals.find(params[:id])
  end

  def new
    @hospital = current_user.hospitals.build

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
      redirect_to hospital_index_path, notice: "病院を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
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
