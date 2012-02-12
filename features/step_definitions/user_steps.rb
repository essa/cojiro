#Given /^the following users:$/ do |table|
#  table.hashes.each do |hash|
#    Factory(:user, hash)
#  end
#end

Given /^the following Twitter users:$/ do |table|
  table.hashes.each do |hash|
    OmniAuth.config.add_mock(:twitter,
                             {:uid => hash[:uid],
                               'provider' => 'twitter',
                               'info'=> { 'name' => hash[:name], 'nickname' => hash[:nickname] }})
  end
end

Given /^I am logged in through Twitter as "([^"]*)"$/ do |name|
  visit "/auth/twitter"
end
