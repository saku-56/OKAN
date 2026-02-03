namespace :consultation_schedule do
  desc "通院予定日が過ぎた予定のstatusをcompletedに変更する"
  task update_status: :environment do
    ConsultationSchedule.scheduled.past_scheduled.find_each(&:completed!)
  end
end
