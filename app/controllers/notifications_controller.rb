class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[update ]
  before_action :require_line_connection, only: %i[edit update]

  def edit
    @medicine_notification = current_user.notifications.find_by(notification_type: "medicine_stock")
    @consultation_notification = current_user.notifications.find_by(notification_type: "consultation_reminder")

    if @medicine_notification.nil? || @consultation_notification.nil?
      redirect_to home_path, alert: "通知設定が見つかりませんでした"
    end
  end

  def update
    if @notification.update(notification_params)
      redirect_to home_path, notice: "通知設定を更新しました"
    else
      # エラーがある場合は、該当する通知設定のインスタンス変数を再設定して再描画
      if @notification.notification_type == "medicine_stock"
        @medicine_notification = @notification
        @consultation_notification = current_user.notifications.find_by(notification_type: "consultation_reminder")
      else
        @consultation_notification = @notification
        @medicine_notification = current_user.notifications.find_by(notification_type: "medicine_stock")
      end
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:enabled, :days_before)
  end

  def require_line_connection
    unless current_user.line_user_id.present?
      redirect_to line_login_required_path, alert: "LINE通知を利用するにはLINE連携が必要です"
    end
  end
end
