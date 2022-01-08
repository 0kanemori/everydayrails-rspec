module LoginSupport
  def sign_in_as(user)
    visit root_path
    click_link "Sign in"
    # 処理が速すぎて、エラーになるのでとりあえずの処置(sleepは避けるべきらしい)
    expect(page).to have_content "Log in" # 応急処置
    fill_in "Email",	with: user.email
    fill_in "Password",	with: user.password
    click_button "Log in"
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end