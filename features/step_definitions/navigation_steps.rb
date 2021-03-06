#Given /^I am on the (.+)$/ do |page_name|
#  visit eval("#{page_name.gsub(' page','').gsub(' ','_')}_path")
#end

Given /^I am on the homepage$/ do
  visit homepage_path
end

Given /^I am on (?:the page for |)the thread "(.+)"$/ do |title|
  @cothread = Cothread.find_by_title(title)
  visit cothread_path(@cothread)
end

When /^I go to (?:the page for |)the thread$/ do
  visit cothread_path(@cothread)
end

When /^I go to (?:the page for |)the thread "(.+)"$/ do |title|
  @cothread = Cothread.find_by_title(title)
  visit cothread_path(@cothread)
end

When /^I go to (?:the page for |)the thread with (English|Japanese) title "(.+)"$/ do |lang, title|
  locale = (lang == "English") ? :en : :ja
  I18n.with_locale(locale) do
    @cothread = Cothread.find_by_title(title)
  end
  visit cothread_path(@cothread)
end
