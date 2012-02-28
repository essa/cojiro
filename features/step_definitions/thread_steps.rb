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
