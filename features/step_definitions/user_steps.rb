Given /^the following users:$/ do |table|
  table.hashes.each do |hash|
    Factory(:user, hash)
  end
end

Given /^I am logged in through Twitter as "([^"]*)"$/ do |name|
  OmniAuth.config.add_mock(:twitter, 
                           {:uid => '12345',
                             'provider' => 'twitter',
                             'info'=> { 'name' => name, 'nickname' => name }})
  visit "/auth/twitter"
end
