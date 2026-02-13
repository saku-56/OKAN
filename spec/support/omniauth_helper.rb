module OmniauthMocks
  # LINEのモック
  def line_mock(uid: "12345")
    OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new({
      provider: "line",
      uid: uid,
      info: {
        name: "LINE太郎"
      },
      credentials: {
        token: "mock_token"
      }
    })
  end

  def line_mock_failure
    OmniAuth.config.mock_auth[:line] = :invalid_credentials
  end

  # Googleのモック
  def google_mock(uid: "67890")
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: uid,
      info: {
        name: "Google テストユーザー",
        email: "test@example.com"
      },
      credentials: {
        token: "mock_google_token"
      }
    })
  end

  def google_mock_failure
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
  end
end

RSpec.configure do |config|
  config.include OmniauthMocks, type: :system
end
