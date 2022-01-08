require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @user = FactoryBot.create(:user)

    @project = FactoryBot.create(:project, owner: @user)
  end

  # ファクトリで関連するデータを生成する
  it "generates associated data from a factory" do
    note = FactoryBot.create(:note)
  end
  
  # ユーザー、プロジェクト、メッセージがあれば有効な状態であること
  it "is valid with a user, project, and message" do
    note = FactoryBot.build(:note)

    expect(note).to be_valid
  end

  # メッセージがなければ無効な状態であること
  it "is invalid without a message" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank") 
  end
  # 文字列に一致するメッセージを検索する
  describe "search message for a term" do
    before do
      @note1 = FactoryBot.create(:note, message: "This is the first note.")
      @note2 = FactoryBot.create(:note, message: "This is the second note.")
      @note3 = FactoryBot.create(:note, message: "First, preheat the oven")
    end
    
    # 一致するデータが見つかるとき
    context "when a match is found" do
      # 検索文字列に一致するメモを返すこと
      it "returns notes that match the search term" do
        expect(Note.search("first")).to include(@note1, @note3)
      end
    end

    # 一致するデータが1件も見つからない時
    context "when not match is found" do
      # 検索結果が1件も見つからなければ空のコレクションを返すこと
      it "returns an empty collection when no results are found" do
        expect(Note.search("message")).to be_empty
      end
    end
  end
  
end
