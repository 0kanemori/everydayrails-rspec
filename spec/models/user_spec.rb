require 'rails_helper'

RSpec.describe User, type: :model do
  # 姓、名、メール、パスワードがあれば有効な状態であること
  it "is valid with a first name, last name, email, and password" do
    expect(FactoryBot.build(:user)).to be_valid
  end
  # 名がなければ無効な状態であること
  it { is_expected.to validate_presence_of :first_name }
  # 姓がなければ無効な状態であること
  it { is_expected.to validate_presence_of :last_name }
  # メールアドレスがなければ無効な状態であること
  it { is_expected.to validate_presence_of :email }
  # 重複したメールアドレスなら無効な状態であること
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  # ユーザーのフルネームを文字列として返すこと
  it "returns a user's full name as a string" do
    user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
    expect(user.name).to eq("John Doe")
  end
end
