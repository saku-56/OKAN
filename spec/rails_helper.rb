require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"

# capybara等ファイルの読み込み設定
Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }

# OmniAuthのテストモードを有効化
OmniAuth.config.test_mode = true

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join("spec/fixtures")
  ]

  config.use_transactional_fixtures = true
  config.filter_rails_from_backtrace!

  # モジュールのinclude
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include LoginMacros
  config.include OmniauthMocks, type: :system

  # Capybaraの設定
  config.before(:each, type: :system) do
    if ENV["CI"]
      # GitHub Actions環境
      driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
    else
      # ローカルDocker環境
      driven_by :remote_chrome
      Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
      Capybara.server_port = 4444
      Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
    end

    # 共通設定
    Capybara.ignore_hidden_elements = false
  end

  config.after(:each, type: :system) do
    OmniAuth.config.mock_auth[:line] = nil
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end
end
