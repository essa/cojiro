# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "csasaki"
    profile "my profile"
    location "Tokyo, Japan"
    mysite "http://www.mysite.com"
    fullname "Cojiro Sasaki"
    remote_avatar_url "http://a1.twimg.com/profile_images/1234567/csasaki.png"
  end

  factory :alice, class: User do
    name "alice"
    fullname "Alice"
    remote_avatar_url "http://example.com/alice.png"
  end

  factory :bob, class: User do
    name "bob"
    fullname "Bob"
    remote_avatar_url "http://example.com/bob.png"
  end

end
