require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let!(:project) { FactoryBot.create(:project, 
    name: "RSpec tutorial",
    owner: user) 
  }

  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    sign_in user
    
    visit root_path

    expect {
      create_or_update_task "New Project", "Test Project", "Trying out Capybara"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect_create_or_update_task "Project was successfully created", "Test Project", user
    end
  end

  # ユーザーは既存のプロジェクトを編集する
  scenario "user updates an existing project" do
    sign_in user

    go_to_project "RSpec tutorial"

    create_or_update_task "Edit", "Test Project", "Trying out Capybara"

    aggregate_failures do
      expect_create_or_update_task "Project was successfully updated", "Test Project", user
      expect(project.reload.name).to eq "Test Project"
    end
  end

  # ユーザーはプロジェクトを完了済みにする
  scenario "user completes a project" do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    sign_in user

    visit project_path(project)

    expect(page).to_not have_content "Completed"

    click_button "Complete"
    expect(project.reload.completed?).to be true
    expect(page).to \
      have_content "Congratulations, this project is complete! "
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end
  
  describe "showing and hiding projects" do
    before do
      FactoryBot.create(:project, 
        name: "Completed Project",
        owner: user, 
        completed: true)
      FactoryBot.create(:project, 
        name: "Incompleted Project",
        owner: user, 
        completed: false)
      sign_in user
      visit root_path
    end
    # ダッシュボードで完了済みのプロジェクトは非表示になる
    scenario "completed projects are hidden" do
      expect(page).to_not have_content "Completed Project"
      expect(page).to have_content "Incompleted Project"
    end

    # 完了済みのプロジェクトのみが表示されること
    scenario "only completed projects are displayed" do
      click_link "Completed project"
      expect(page).to have_content "Completed Project"
      expect(page).to_not have_content "Incompleted Project"
    end
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def create_or_update_task(action, project_name, description)
    click_link action
    fill_in_name_and_description project_name, description

    case action
    when "New Project"
      click_button "Create Project"
    when "Edit"
      click_button "Update Project"
    end
  end

  def fill_in_name_and_description(name, description)
    fill_in "Name", with: name
    fill_in "Description", with: description
  end

  def expect_create_or_update_task(success_message, project_name, user)
    expect(page).to have_content success_message
    expect(page).to have_content project_name
    expect(page).to have_content "Owner: #{user.name}"
  end
end
