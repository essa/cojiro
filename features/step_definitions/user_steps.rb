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
  visit "/"
  click_link "Sign in through Twitter"
end
