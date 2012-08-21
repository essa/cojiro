When /^I click on the edit button next to the "([^"]*)" field$/ do |attr_name|
  within(:xpath, "//span[contains(@data-attribute,'#{attr_name}')]") do
    click_on("Edit")
  end
end

When /^I enter the text "([^"]*)" into the "([^"]*)" field$/ do |text, attr_name|
  within(:xpath, "//span[contains(@data-attribute,'#{attr_name}')]") do
    fill_in attr_name, :with => text
  end
end

When /^I click the save button next to the "([^"]*)" field$/ do |attr_name|
  within(:xpath, "//span[contains(@data-attribute,'#{attr_name}')]") do
    click_on("Save")
  end
end
