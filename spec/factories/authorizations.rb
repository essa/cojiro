# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authorization do
    provider "twitter"
    uid "12345"
    user_id "1"
  end
end
