class ConsultationSchedulesController < ApplicationController
  before_action :set_hospital, only: %i[create]

  def create
    @consultation_schedule = current_user.consultation_schedules.build(consultation_schedule_params)
    # @hospital.id を hospital_id に設定
    @consultation_schedule.hospital_id = @hospital.id

    if @consultation_schedule.save
        redirect_to hospital_path(@hospital), notice: "通院予定日を登録しました。"
    else
        @next_visit = @consultation_schedule
        flash.now[:danger] = "通院予定日登録に失敗しました。"
        render "hospitals/show", status: :unprocessable_entity
    end
  end

  private

  def set_hospital
    @hospital = current_user.hospitals.find_by(uuid: params[:hospital_id])
  end

  def consultation_schedule_params
    params.require(:consultation_schedule).permit(:visit_date)
  end
end
