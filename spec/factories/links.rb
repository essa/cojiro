# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    url "MyString"
    title "MyString"
    summary "MyText"
    user nil
    embed_data "MyText"
  end
end
