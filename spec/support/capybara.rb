# :remote_chromeという名前でドライバーを登録する
Capybara.register_driver :remote_chrome do |app|
  # Chromeブラウザの起動オプションを設定するためのオブジェクトを作成
  options = Selenium::WebDriver::Chrome::Options.new
  # 画面を表示せずにブラウザを動かす
  options.add_argument('--headless')
  # サンドボックスモードを無効化(Dockerコンテナですでに隔離されているため)
  options.add_argument('--no-sandbox')
  # 共有メモリの使用を無効化
  options.add_argument('--disable-dev-shm-usage')

  # 実際のドライバーを作成
  Capybara::Selenium::Driver.new(
  app,                                    # Railsアプリケーション
  browser: :remote,                       # リモートブラウザを使う
  url: 'http://chrome:4444/wd/hub',      # chromeコンテナの接続先
  options: options                      # 上で設定したオプション
  )
end
