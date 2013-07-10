Given /^the following thread exists:$/ do |table|
  hash = table.rows_hash
  u = User.find_by_name(hash.delete("user"))
  @cothread = @translatable = FactoryGirl.create(:cothread, u.nil? ? hash : hash.merge(:user => u))
end

Given /^the following threads exist:$/ do |table|
  table.hashes.each do |hash|
    u = User.find_by_name(hash.delete("user"))
    FactoryGirl.create(:cothread, u.nil? ? hash : hash.merge(:user => u))
  end
end

Given /^the thread has the following links:$/ do |table|
  raise Error, '@cothread not defined' unless @cothread.is_a?(Cothread)
  table.hashes.each do |hash|
    u = User.find_by_name(hash.delete('user'))
    link = FactoryGirl.create(:link, u.nil? ? hash : hash.merge(:user => u))
    @cothread.links << link
  end
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

When /^I delete the thread "([^"]*)"$/ do |title|
  cothread = Cothread.find_by_title(title)
  visit cothread_path(cothread)
  handle_js_confirm do
    click_link('Delete thread')
  end
end

Then /^I should see the new thread "([^"]*)"$/ do |title|
  @cothread = Cothread.find_by_title(title)
  page.should have_content(@cothread.title)
  page.should have_content(@cothread.summary)
end

Then /^I should see that the thread was created on "([^"]*)"$/ do |date|
  page.find('span.status', :text => /STARTED/).first(:xpath, './/..').find('span.date').text.should == date
end

Then /^I should see that the thread was updated on "([^"]*)"$/ do |date|
  page.find('span.status', :text => /LAST UPDATED/).first(:xpath, './/..').find('span.date').text.should == date
end

Then /^I should see the new thread page$/ do
  page.should have_css("form", :id => "new_cothread")
end

Then /^the title of the thread should be "([^"]*)"$/ do |val|
  @cothread.reload
  @cothread.title.should == val
end

Then /^the summary of the thread should be "([^"]*)"$/ do |val|
  @cothread.reload
  @cothread.summary.should == val
end
