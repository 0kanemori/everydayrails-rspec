FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name "Aaron"
    last_name "Sumner"
    sequence(:email) { |n| "tester#{n}@example.com" }
    password "dottle-noubeau-pavilion-tights-furze"
  end
end
