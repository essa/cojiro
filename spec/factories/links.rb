# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:url) { |n| "http://www.mywebsite#{n}.com/" }

  factory :link do
    url { FactoryGirl.generate(:url) }
    after(:build) { |l| l.user ||= FactoryGirl.create(:alice) }
    after(:stub) { |l| l.user ||= FactoryGirl.build_stubbed(:alice) }

    # source locale and no title in that locale is invalid
    trait :invalid do
      source_locale 'en'
    end
  end

end
