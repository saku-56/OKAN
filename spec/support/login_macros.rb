module LoginMacros
  def login(user)
    visit sign_in_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
  end
end
