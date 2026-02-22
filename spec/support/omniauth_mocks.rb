module OmniauthMocks
  # LINEのモック
  def line_mock(uid: "12345")
    OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new({
      provider: "line",
      uid: uid,
      info: {
        email: 'test@example.com'
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
        email: "test@example.com"
      }
    })
  end

  def google_mock_failure
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
  end
end
