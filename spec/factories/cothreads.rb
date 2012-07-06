# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:title) { |n| "title #{n}" }
  sequence(:summary) { |n| "summary #{n}"}

  factory :cothread do
    title { FactoryGirl.generate(:title) }
    summary { FactoryGirl.generate(:summary) }
    user
  end
end
