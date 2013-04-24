# ref: http://blog.spoolz.com/2012/07/09/small-revelation-factorygirl-build_stubbed-associations-and-let/

FactoryGirl.define do
  sequence(:title) { |n| { "en" => "title #{n}" } }
  sequence(:summary) { |n| { "en" => "summary #{n}" } }

  factory :cothread do
    title { FactoryGirl.generate(:title) }
    summary { FactoryGirl.generate(:summary) }
    after(:build) { |c| c.user ||= FactoryGirl.create(:alice) }
    after(:stub) { |c| c.user ||= FactoryGirl.build_stubbed(:alice) }
  end
end
