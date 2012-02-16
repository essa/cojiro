#Given /^I am on the (.+)$/ do |page_name|
#  visit eval("#{page_name.gsub(' page','').gsub(' ','_')}_path")
#end

Given /^I am on the homepage$/ do
  visit '/'
end
