When /^I click (?:on |)"([^"]*)"$/ do |link_text|
  # ref: https://github.com/jnicklas/capybara/issues/379
  begin
    find("a", :text => /#{link_text}/).click
  rescue Capybara::ElementNotFound
    click_on(link_text)
  end
end

When /^I click on the (submit|cancel) button in the link$/ do |type|
  @el.find("button[type='#{type}']").click
end

When /^I click on the editable text "([^"]*)"$/ do |clickable_text|
  span = find("span.editable", text: clickable_text)
  @el = span.first(:xpath, ".//ancestor::div[@class='link']")
  span.click
end

When 'I enter "$text" into the $tag in the link' do |text, tag|
  @el.find(tag).set(text)
end

When /^I select "([^"]*)" from the drop-down list$/ do |option|
  select(option)
end

When "I fill in \"$field\" with \"$text\"" do |field, text|
  fill_in(field, with: text)
end

When /^I enter the url "([^"]*)" into the dialog box$/ do |url|
  fill_in("url", with: url)
end

# ref: http://pivotallabs.com/users/mgehard/blog/articles/1671-waiting-for-jquery-ajax-calls-to-finish-in-cucumber
When /^I wait for the AJAX call to finish$/ do
  wait_until do
    page.evaluate_script('$.active') == 0
  end
end

Then /I (should|should not) see the editable text "([^"]*)" in the link/ do |expectation, text|
  @el.send(expectation.gsub(' ', '_'), have_selector("span.editable", text: text))
end

Then /^the "([^"]*)" field should say "(.*)"$/ do |name, val|
  page.should have_field(name, :with => val)
end

Then /^the "([^"]*)" field should be blank$/ do |name|
  page.should have_field(name, :with => '')
end

Then /^the "([^"]*)" field should have a red box around it$/ do |name|
  id = page.first('label', text: name)['for']
  control_group = find_by_id(id).first(:xpath, ".//ancestor::div[contains(@class,'control-group')]")
  control_group[:class].should include('error')
end

Then /^the "([^"]*)" field should have an error message:? "([^"]*)"$/ do |name, msg|
  id = page.first('label', text: name)['for']
  control_group = find_by_id(id).first(:xpath, ".//ancestor::div[contains(@class,'control-group')]")
  control_group.first('.help-block').should have_text(msg)
end

Then 'I should see a $tag with "$val" in the link' do |tag, val|
  @el.first(tag).value.should == val
end

Then /I (should|should not) see a popover with "([^"]*)"/ do |expectation, val|
  page.send(expectation.gsub(' ', '_'), have_selector('.popover .popover-content', text: val))
end

Then /^I should see a (submit|cancel) button in the link$/ do |type|
  @el.should have_selector("button[type='#{type}']")
end

Then /^I should see an? (error|success|notice|info) message(?::? "(.*)")?$/ do |msg_type,message|
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

Then /^I (should|should not) see the text:? "([^"]*)" in the (thread|threads list|navbar)$/ do |expectation, text, class_tag|
  within(:css, ".#{class_tag.gsub(/ /,'_')}") do
    page.send(expectation.gsub(' ','_'),have_content(text))
  end
end

Then /^I should see the translated text "([^"]*)" in the (thread|threads list)$/ do |text, class_tag|
  within(:css, ".#{class_tag.gsub(/ /,'_')}") do
    page.should have_xpath('//span[contains(@class,"translated")]', :text => text)
  end
end

Then /^I should see the untranslated text "([^"]*)" in the (thread|threads list)$/ do |text, class_tag|
  within(:css, ".#{class_tag.gsub(/ /,'_')}") do
    page.should have_xpath('//span[contains(@class,"untranslated")]', :text => text)
  end
end

Then /^I should see a note "([^"]*)" next to the thread "([^"]*)" in the threads list$/ do |text, title|
  within(:css, ".threads_list") do
    row = find(:xpath, "//tr[./td[contains(.,\"#{title}\")]]")
    row.should have_content(text)
  end
end

Then /^I should see a "([^"]*)" tag next to the thread "([^"]*)" in the threads list$/ do |tag_text, title|
  within(:css, ".threads_list") do
    row = find(:xpath, "//tr[./td[contains(.,\"#{title}\")]]")
    row.should have_selector('span.label.label-info', :text => tag_text)
  end
end

Then /^I should see a "new" tag next to the thread "([^"]*)"$/ do |title|
  within(:css, ".threads_list") do
    row = find(:xpath, "//tr[./td[contains(.,\"#{title}\")]]")
    row.should have_selector('span.label.label-info', :text => title)
  end
end

Then /^show me the page$/ do
  save_and_open_page
end
