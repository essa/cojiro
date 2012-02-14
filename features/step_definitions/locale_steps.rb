Given /^my locale is "([^"]*)"$/ do |locale|
  I18n.locale = locale.to_sym
end
