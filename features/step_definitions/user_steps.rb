module OmniAuthHelpers
  def add_twitter_mock(uid, name, nickname)
    OmniAuth.config.add_mock(:twitter,
                             { :provider => 'twitter',
                               :uid => uid,
                               :info => { :name => name, :nickname => nickname }})
  end
end
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
