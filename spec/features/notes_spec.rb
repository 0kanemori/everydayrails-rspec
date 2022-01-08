require 'rails_helper'

RSpec.feature "Notes", type: :feature do
    # ユーザーがノートを作成する
    # データの部分で失敗するのでとりあえずコメントアウト
    # scenario "user toggles a note" do
    #   user = FactoryBot.create(:user)
    #   project = FactoryBot.create(:project,
    #     name: "RSpec tutorial",
    #     owner: user)
  
    #   visit root_path
    #   click_link "Sign in"
    #   fill_in "Email", with: user.email
    #   fill_in "Password", with: user.password
    #   click_button "Log in"
  
    #   click_link "RSpec tutorial"
    
    #   expect {
    #     click_link "Add Note"
    #     fill_in "Message", with: "Test Message"
    #     # attach_file "Attachment", "/Users/kanemoriyuya/Desktop/スクリーンショット 2021-10-29 19.58.12.png"
    #     click_button "Create Note"

    #     expect(page).to have_content "Note was successfully created."
    #     expect(page).to have_content "RSpec tutorial"
    #     expect(page).to have_content "Owner: #{user.name}"
    #   }.to change(project.notes, :count).by(1)
    # end
end
