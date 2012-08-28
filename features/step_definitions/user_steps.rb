World(OmniAuthHelpers)

Given /^I am logged into Twitter as the following user:$/ do |table|
  add_twitter_mock(table.rows_hash[:uid],
                   table.rows_hash[:name],
                   table.rows_hash[:nickname])
end

Given /^I am logged in through Twitter as the following user:$/ do |table|
  add_twitter_mock(table.rows_hash[:uid],
                   table.rows_hash[:name],
                   table.rows_hash[:nickname])
  visit homepage_path
  click_link "Sign in through Twitter"
  # give time for sign-in
  sleep 0.5
end

Given /^the following users exist:$/ do |table|
  table.hashes.each do |hash|
    FactoryGirl.create(:user, hash)
  end
end

Then /^the following user should exist:$/ do |table|
  (name = table.rows_hash.delete('name')).should be
  (user = User.find_by_name(name)).should be
  table.rows_hash.each do |field, value|
    user.send(field).should == value
  end
end
