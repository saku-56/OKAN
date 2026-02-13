OmniAuth.config.test_mode = true

module OmniauthMocks
  def line_mock(uid: '12345')
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
end

RSpec.configure do |config|
  config.include OmniauthMocks

  config.before(:each) do
    OmniAuth.config.test_mode = true
  end

  config.after(:each) do
    OmniAuth.config.mock_auth[:line] = nil
  end
end
