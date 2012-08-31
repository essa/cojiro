Given /^my locale is "(#{I18n.available_locales.join('|')})"$/ do |locale|
  I18n.locale = locale.to_sym
end

Given /^it has the following translations to "(#{I18n.available_locales.join('|')})":$/ do |locale, table|
  Globalize.with_locale(locale) do
    hash = table.rows_hash
    @translatable.update_attributes!(hash) unless !@translatable
  end
end

# this should really involve clicking on a drop-down to change the locale,
# but the drop-down is not there yet so for now it just sets the locale
When /^I switch my locale to "(#{I18n.available_locales.join('|')})"$/ do |locale|
  I18n.locale = locale.to_sym
end
