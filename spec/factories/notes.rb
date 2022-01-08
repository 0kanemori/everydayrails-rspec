FactoryBot.define do
  factory :note do
    sequence(:message) { |n| "My important note#{n}." }
    association :project
    user { project.owner }
  end
end
