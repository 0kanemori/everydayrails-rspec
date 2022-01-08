require 'rails_helper'

RSpec.describe Project, type: :model do
  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "doese not allow duplicate project names per user" do
    user = FactoryBot.create(:user)

    FactoryBot.create(:project, name: "Test Project", owner: user)

    new_project = FactoryBot.build(:project, name: "Test Project", owner: user)

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken") 
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    user = FactoryBot.create(:user)

    FactoryBot.create(:project, name: "Test Project", owner: user)

    other_user = FactoryBot.create(:user)

    other_project = FactoryBot.create(:project, name: "Test Project", owner: other_user)

    expect(other_project).to be_valid
  end

  # たくさんのメモがついていること
  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  # 締切日が過ぎていれば遅延していること
  it "is late when the due date is past today" do
    project = FactoryBot.create(:project, :due_yesterday)
    expect(project).to be_late
  end

  # 締切日が今日ならスケジュール通りであること
  it "is on time when the due date is today" do
    project = FactoryBot.create(:project, :due_today)
    expect(project).to_not be_late
  end

  # 締切日が未来ならスケジュール通りであること
  it "is on time when the due date is in the future" do
    project = FactoryBot.create(:project, :due_tomorrow)
    expect(project).to_not be_late
  end
end
