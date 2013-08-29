Then /^there (should|should not) exist a link with (?:(English|Japanese) |)(title|summary) "([^"]*)" in the database$/ do |expectation, language, attr_name, value|
  locale = language_to_locale(language)
  Globalize.with_locale(locale || I18n.locale) do
    @link = Link.send("find_by_#{attr_name}", value)
    @link.send(expectation.gsub(' ', '_'), be)
  end
end

Then /^the link should have an? (English|Japanese) (title|summary) "([^"]*)"$/ do |language, attr_name, value|
  locale = language_to_locale(language)
  @link.translation_for(locale).send(attr_name).should == value
end
