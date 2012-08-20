# to get default_url_options working in rspec & cucumber, see: https://github.com/rspec/rspec-rails/issues/255
class ActionDispatch::Routing::RouteSet
  def url_for_with_locale_fix(options)
    url_for_without_locale_fix(options.merge(:locale => I18n.locale))
  end

  alias_method_chain :url_for, :locale_fix
end
