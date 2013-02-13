# to get default_url_options working in rspec & cucumber, see: https://github.com/rspec/rspec-rails/issues/255
class ActionDispatch::Routing::RouteSet
  def url_for_with_locale_fix(options)
    url_for_without_locale_fix(options.merge(:locale => I18n.locale))
  end

  alias_method_chain :url_for, :locale_fix
end

# ref: http://stackoverflow.com/questions/1987354/how-to-set-locale-default-url-options-for-functional-tests-rails/8920258#8920258
class ActionController::TestCase
  module Behavior
    def process_with_default_locale(action, parameters = nil, session = nil, flash = nil, http_method = 'GET')
      parameters = { :locale => I18n.locale }.merge( parameters || {} ) unless I18n.locale.nil?
      process_without_default_locale(action, parameters, session, flash, http_method)
    end
    alias_method_chain :process, :default_locale
  end
end
