Given /^the following thread exists:$/ do |table|
  hash = table.rows_hash
  u = User.find_by_name(hash.delete("user"))
  Factory(:cothread, u.nil? ? hash : hash.merge(:user => u))
end

Given /^I am on the thread "([^"]*)"$/ do |title|
  cothread = Cothread.find_by_title(title)
  visit cothread_path(cothread)
end

When /^I create the following thread:$/ do |table|
  # should be homepage_path but default_url_options not picked up by cucumber
  visit homepage_path
  click_on('Start a thread')
  table.rows_hash.each do |field,value|
    fill_in(field, :with => value)
  end
  click_button('Create thread')
end

Then /^I should see the new thread "([^"]*)"$/ do |title|
  cothread = Cothread.find_by_title(title)
  page.should have_content(cothread.title)
  page.should have_content(cothread.summary)
end

Then /^I should see the new thread page$/ do
  page.should have_css("form", :id => "new_cothread")
end
