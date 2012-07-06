# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:name) { |n| "name #{n}"}

  factory :user do
    name { FactoryGirl.generate(:name) }
    fullname "A. FullName"
    remote_avatar_url "http://example.com/user.png"
  end

  factory :alice, parent: :user do
    name "alice"
    fullname "Alice in Wonderland"
    profile "If I had a world of my own, everything would be nonsense."
    location "Wonderland"
    mysite "http://www.alice-in-wonderland.com"
    remote_avatar_url "http://example.com/alice.png"
  end

  factory :bob, parent: :user do
    name "bob"
    fullname "Bob the Builder"
    profile "I fix things."
    location "United Kingdom"
    mysite "http:://www.bobthebuilder.com"
    remote_avatar_url "http://example.com/bob.png"
  end

  factory :csasaki, parent: :user do
    name "csasaki"
    fullname "Cojiro Sasaki"
    profile "I like dicing blue chickens."
    location "Fukui, Japan"
    mysite "http://cojiro.jp"
    remote_avatar_url "http://example.com/csasaki.png"
  end
end
