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
    u = User.find_by_name(name = hash.delete('user')) || raise(ArgumentError, "User @#{name} not found")
    Globalize.with_locale(hash['source_locale'] || I18n.locale) do
      link = FactoryGirl.build(:link, hash)
      FactoryGirl.create(:comment, cothread: @cothread, link: link, user: u)
    end
  end
end

Given /^I have added the link "([^"]*)"$/ do |url|
  step 'I click on "Add a link"'
  fill_in('url', with: url)
  click_on('Go!')
  step 'I wait for the AJAX call to finish'
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

When /^I click (?:on )the edit button in the statbar$/ do
  page.find('a#thread-edit').click()
end

Then /^I should see the (?:new |)thread "([^"]*)"$/ do |title|
  @cothread = Cothread.find_by_title(title)
  page.should have_content(@cothread.title)
  page.should have_content(@cothread.summary)
end

Then /^I should see that the thread was created on "([^"]*)"$/ do |date|
  page.find('li.credit').should have_content(date)
end

Then /^I should see that the thread was created by "([^"]*)"$/ do |name|
  page.find('li.credit').should have_content(name)
end

Then /^I should see that the thread was updated on "([^"]*)"$/ do |date|
  page.find('span.status', :text => /LAST UPDATED/).first(:xpath, './/..').find('span.date').text.should == date
end

Then /^I should see that the thread has ([^"]*) links?$/ do |num|
  page.first('span.stat').should have_content(num)
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

Then /^I should see a link with url "([^"]*)" in the thread$/ do |url|
  page.should have_css(".link a[href='#{url}']")
  a = first(".link a[href='#{url}']")
  @el = a.first(:xpath, ".//ancestor::div[@class='link']")
end

Then /^the (?:.+ |)element should have the title "([^"]*)"$/ do |text|
  @el.first('h3.title').should have_text(text)
end

Then /^the (?:.+ |)element should have the summary "(.*)"$/ do |text|
  @el.first('p.summary').should have_text(text)
end

Then /^I should see the avatar of "([^"]*)" in the statbar$/ do |name|
  u = User.find_by_name(name) || raise(ArgumentError, "User @#{name} not found")
  page.find('.statbar').should have_css("img[src='#{u.avatar_mini_url}']")
end
