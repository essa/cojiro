# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    url "http://www.example.com"
    after(:build) { |l| l.user ||= FactoryGirl.create(:alice) }
    after(:stub) { |l| l.user ||= FactoryGirl.build_stubbed(:alice) }
  end
end
