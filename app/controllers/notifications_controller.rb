class NotificationsController < ApplicationController
  def edit
    @medicine_notification = current_user.notifications.find_by(notification_type: 'medicine_stock')
    @consultation_notification = current_user.notifications.find_by(notification_type: 'consultation_reminder')

    if @medicine_notification.nil? || @consultation_notification.nil?
      redirect_to home_path, alert: "通知設定が見つかりませんでした"
    end
  end

  def update
    @medicine_notification = current_user.notifications.find_by(notification_type: 'medicine_stock')
    @consultation_notification = current_user.notifications.find_by(notification_type: 'consultation_reminder')

    # assign_attributes で値をセットするが、まだ保存しない
    @medicine_notification.assign_attributes(
      enabled: params[:medicine_notification][:enabled] == '1',
      days_before: params[:medicine_notification][:days_before]
    )

    @consultation_notification.assign_attributes(
      enabled: params[:consultation_notification][:enabled] == '1',
      days_before: params[:consultation_notification][:days_before]
    )

    # バリデーションチェック
    if @medicine_notification.valid? && @consultation_notification.valid?
      # 両方とも valid なら保存
      ActiveRecord::Base.transaction do
        @medicine_notification.save!
        @consultation_notification.save!
      end
      redirect_to home_path, notice: '通知設定を更新しました'
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render :edit, status: :unprocessable_entity
  end
end