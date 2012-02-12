#Given /^the following users:$/ do |table|
#  table.hashes.each do |hash|
#    Factory(:user, hash)
#  end
#end

Given /^I am logged in through Twitter as the following user:$/ do |table|
  OmniAuth.config.add_mock(:twitter,
                           { :provider => 'twitter',
                             :uid => table.rows_hash[:uid],
                             :info => { :name => table.rows_hash[:name], :nickname => table.rows_hash[:nickname] }})
  visit "/auth/twitter"
end
