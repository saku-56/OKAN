class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    provider = "google"
    # Googleから返ってきた情報を取得
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{ provider }") if is_navigational_format?
    else
      session["devise.#{ provider }_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    # 認証失敗時
    redirect_to root_path, alert: "Google認証に失敗しました"
  end
end
