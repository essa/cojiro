When /^I create the following thread:$/ do |table|
  visit homepage_path
  click_on('Start a thread')
  table.rows_hash.each do |field,value|
    fill_in(field, :with => value)
  end
  click_button('Create thread')
end

Then /^I should see the new thread "([^"]*)"$/ do |title|
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the new thread page$/ do
  pending # express the regexp above with the code you wish you had
end
