When /^I click on "([^"]*)"$/ do |link_text|
  click_on(link_text)
end

When /^I select "([^"]*)" from the drop-down list$/ do |option|
  select(option)
end

# ref: http://pivotallabs.com/users/mgehard/blog/articles/1671-waiting-for-jquery-ajax-calls-to-finish-in-cucumber
When /^I wait for the AJAX call to finish$/ do
  wait_until do
    page.evaluate_script('$.active') == 0
  end
end

Then /^I should see an? (error|success|notice) message(?:: "(.*)")?$/ do |msg_type,message|
  page.should have_css(".#{msg_type.gsub('notice','message')}", :text => message)
end

Then /^I should see a link to "([^"]*)"$/ do |link_text|
  page.should have_link(link_text)
end

Then /^I should not see a link to "([^"]*)"$/ do |link_text|
  page.should_not have_link(link_text)
end

Then /^I (should|should not) see the text:? "([^"]*)"$/ do |expectation, text|
  page.send(expectation.gsub(' ','_'),have_content(text))
end

Then /^I (should|should not) see the text:? "([^"]*)" in the (thread|threads list)$/ do |expectation, text, class_tag|
  within(:css, "##{class_tag.gsub(/ /,'_')}") do
    page.send(expectation.gsub(' ','_'),have_content(text))
  end
end

Then /^I should see the translated text "([^"]*)" in the (thread|threads list)$/ do |text, class_tag|
  within(:css, "##{class_tag.gsub(/ /,'_')}") do
    page.should have_xpath('//span[contains(@class,"translated")]', :text => text)
  end
end

Then /^I should see the untranslated text "([^"]*)" in the (thread|threads list)$/ do |text, class_tag|
  within(:css, "##{class_tag.gsub(/ /,'_')}") do
    page.should have_xpath('//span[contains(@class,"untranslated")]', :text => text)
  end
end

Then /^I should see a note "([^"]*)" next to the thread "([^"]*)" in the threads list$/ do |text, title|
  within(:css, "#threads_list") do
    row = find(:xpath, "//tr[./td[contains(.,\"#{title}\")]]")
    row.should have_content(text)
  end
end

Then /^I should see a "([^"]*)" tag next to the thread "([^"]*)" in the threads list$/ do |tag_text, title|
  within(:css, "#threads_list") do
    row = find(:xpath, "//tr[./td[contains(.,\"#{title}\")]]")
    row.should have_selector('span.label.label-info', :text => tag_text)
  end
end

Then /^I should see a "new" tag next to the thread "([^"]*)"$/ do |title|
  within(:css, "#threads_list") do
    row = find(:xpath, "//tr[./td[contains(.,\"#{title}\")]]")
    row.should have_selector('span.label.label-info', :text => title)
  end
end


Then /^show me the page$/ do
  save_and_open_page
end
