require File.join(Rails.root, "spec", "support", "fixture_helpers.rb")

# ref: http://stackoverflow.com/questions/7907737/how-to-include-a-module-in-a-factory-girl-factory
module FactoryGirl
  class DefinitionProxy
    include FixtureHelpers
  end
end

FactoryGirl.define do
  sequence(:name) { |n| "name #{n}"}

  factory :user do
    name { FactoryGirl.generate(:name) }
    fullname "A. FullName"
    avatar fixture("user.png")
  end

  factory :alice, parent: :user do
    name "alice"
    fullname "Alice in Wonderland"
    profile "If I had a world of my own, everything would be nonsense."
    location "Wonderland"
    mysite "http://www.alice-in-wonderland.com"
    avatar fixture("alice.png")
    initialize_with { User.find_or_create_by_name("alice") }
  end

  factory :bob, parent: :user do
    name "bob"
    fullname "Bob the Builder"
    profile "I fix things."
    location "United Kingdom"
    mysite "http:://www.bobthebuilder.com"
    avatar fixture("bob.png")
    initialize_with { User.find_or_create_by_name("bob") }
  end

  factory :csasaki, parent: :user do
    name "csasaki"
    fullname "Cojiro Sasaki"
    profile "I like dicing blue chickens."
    location "Fukui, Japan"
    mysite "http://cojiro.jp"
    avatar fixture("csasaki.png")
    initialize_with { User.find_or_create_by_name("csasaki") }
  end
end
