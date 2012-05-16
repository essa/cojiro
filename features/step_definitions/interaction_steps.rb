When /^I click on "([^"]*)"$/ do |link_text|
  click_on(link_text)
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
