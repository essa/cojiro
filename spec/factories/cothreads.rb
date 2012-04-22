# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cothread do
    title "Co-working spaces in Tokyo"
    summary "I\'m gathering blog posts on co-working spaces in Tokyo."
    user
  end
end
