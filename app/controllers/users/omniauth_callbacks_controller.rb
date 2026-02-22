class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include OmniauthHelper

  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    callback_for(:google_oauth2)
  end

  def line
    auth = request.env["omniauth.auth"]

    # ここで auth が nil でないことを確認
    if auth.nil?
      redirect_to root_path, alert: "LINE認証情報の取得に失敗しました"
      return
    end

    if user_signed_in?
      handle_line_connection(auth)
    else
      callback_for(:line)
    end
  end

  # 認証失敗時
  def failure
    provider = request.env["omniauth.error.strategy"]&.name || "unknown"
    redirect_to root_path, alert: "#{provider_name(provider)}認証に失敗しました"
  end

  private

  # LINE以外でログインしたユーザーのLINE連携処理
  def handle_line_connection(auth)
    line_user_id = auth["uid"]

    # 既に他のユーザーが使用していないかチェック
    existing_user = User.find_by(line_user_id: line_user_id)

    if existing_user && existing_user.id != current_user.id
      redirect_to home_path, alert: "このLINEアカウントは既に他のユーザーに連携されています"
      return
    end

    # line_user_idのみを保存
    if current_user.update(line_user_id: line_user_id)
      redirect_to edit_notifications_path, notice: "LINE連携が完了しました"
    else
      redirect_to home_path, alert: "LINE連携に失敗しました"
    end
  end

  # LINEログインの処理
  def callback_for(provider)
    # GoogleやLINEから返ってきた情報を取得
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name(provider)) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end
