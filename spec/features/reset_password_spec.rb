require 'rails_helper'

RSpec.feature "Reset Password", type: :feature do
  include ActiveJob::TestHelper

  # ユーザーはパスワードリセットメールを受け取る
  scenario "user successfully receives a password reset mail" do
    FactoryBot.create(:user, email: "test@example.com")
    visit new_user_session_path
    click_link "Forgot your password?"

    perform_enqueued_jobs do
      fill_in "Email", with: "test@example.com"
      click_button "Send me reset password instructions"

      expect(page).to have_content "You will receive an email with instructions on how to reset your password in a few minutes."
      expect(current_path).to eq new_user_session_path
    end

    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.to).to eq ["test@example.com"]
      expect(mail.from).to eq ["please-change-me-at-config-initializers-devise@example.com"]
      expect(mail.subject).to eq "Reset password instructions"
      expect(mail.body).to match "Hello test@example.com"
      expect(mail.body).to match "Change my password"  
    end
  end
end
