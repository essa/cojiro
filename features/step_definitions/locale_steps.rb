Given /^my locale is "(#{Cojiro::Application.config.base_languages.join('|')})"$/ do |locale|
  I18n.locale = locale.to_sym
end

Given /^it has the following translations to "(#{Cojiro::Application.config.base_languages.join('|')})":$/ do |locale, table|
  Globalize.with_locale(locale) do
    hash = table.rows_hash
    @translatable.update_attributes!(hash) unless !@translatable
  end
end

# this should really involve clicking on a drop-down to change the locale,
# but the drop-down is not there yet so for now it just sets the locale
When /^I switch my locale to "(#{Cojiro::Application.config.base_languages.join('|')})"$/ do |locale|
  I18n.locale = locale.to_sym
end
