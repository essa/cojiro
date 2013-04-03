When /^I click on the edit button next to the "([^"]*)" field$/ do |field_name|
  within(:xpath, "//*[contains(@id,'#{field_name}')]") do
    click_on("Edit")
  end
end

When /^I enter the text "([^"]*)" into the "([^"]*)" field$/ do |text, field_name|
  within(:xpath, "//*[contains(@id,'#{field_name}')]") do
    fill_in field_name, :with => text
  end
end

When /^I click the save button next to the "([^"]*)" field$/ do |field_name|
  within(:xpath, "//*[contains(@id,'#{field_name}')]") do
    click_on("Save")
  end
end
