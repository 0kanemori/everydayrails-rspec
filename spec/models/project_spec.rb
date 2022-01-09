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

  # 上記2つのテストを簡略化したもの
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

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

  describe "showing and hiding projects" do
    let(:user) { FactoryBot.create(:user) }
    before do
      @completed_project = FactoryBot.create(:project, 
        name: "Completed Project",
        completed: true,
        owner: user
      )
      @incompleted_project = FactoryBot.create(:project, 
        name: "Incompleted Project",
        completed: false,
        owner: user
      )
    end
    # 完了済みプロジェクトだけが取得できること
    it "is able to retrieve competed projects" do
      expect(user.projects.complete(true)).to eq [@completed_project]
    end
  
    # 完了済みでないプロジェクトが取得できること
    it "is able to retrieve incompeted projects" do
      expect(user.projects.complete([false, nil])).to eq [@incompleted_project]
    end
  end
end
