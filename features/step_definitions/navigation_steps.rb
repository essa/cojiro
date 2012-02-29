#Given /^I am on the (.+)$/ do |page_name|
#  visit eval("#{page_name.gsub(' page','').gsub(' ','_')}_path")
#end

Given /^I am on the homepage$/ do
  visit homepage_path
end

When /^I go to the (.+)$/ do |page_name|
  visit eval("#{page_name.gsub(' page','').gsub(' ','_')}_path")
end

Then /^I should see a link to "([^"]*)" in the navigation bar$/ do |link|
  within '.navbar' do
    page.should have_link(link)
  end
end
