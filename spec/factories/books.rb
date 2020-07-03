FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "The book of life vol (#{n})" }
    yop { rand(1890...Time.now.year) }
    category

    after(:create) do |book|
      book.authors << create(:author, is_alive: false, yob: book.yop - rand(15..50))
    end
  end
end
