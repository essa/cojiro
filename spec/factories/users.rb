# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "cojiro"
    profile "my profile"
    location "Tokyo, Japan"
    mysite "http://www.mysite.com"
    fullname "Cojiro Sasaki"
  end
end
