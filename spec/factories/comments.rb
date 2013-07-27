# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:text) { |n| "text #{n}" }

  factory :comment do
    text { FactoryGirl.generate(:text) }
    cothread
  end
end
