require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  # ユーザーがタスクの状態を切り替える
  scenario "user toggles a task", js: true do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project,
      name: "RSpec tutorial",
      owner: user)
    task = project.tasks.create!(name: "Finish RSpec tutorial")

    visit root_path
    click_link "Sign in"
    # 処理が速すぎて、エラーになるのでとりあえずの処置(sleepは避けるべきらしい)
    expect(page).to have_content "Log in" # 応急処置
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    click_link "RSpec tutorial"
    expect(page).to have_content "Project" # 応急処置

    check "Finish RSpec tutorial"
    expect(page).to have_content "Project" # 応急処置

    expect(page).to have_css "label#task_#{task.id}.completed"
    expect(task.reload).to be_completed
    
    uncheck "Finish RSpec tutorial"
    expect(page).to have_content "Project"# 応急処置

    expect(page).to_not have_css "label#task_#{task.id}.completed"
    expect(task.reload).to_not be_completed
  end
end
