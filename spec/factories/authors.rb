FactoryBot.define do
  factory :author do
    sequence(:first_name) { |n| "John (#{n})" }
    sequence(:last_name) { |n| "Wick (#{n})" }
    yob { rand(1890...Time.now.year) }
    is_alive { false }
  end
end
