module MockModels
  ["cothread", "user", "authorization"].each do |model_name|
  eval <<-END_RUBY
    def mock_#{model_name}(stubs={})
    (@mock_#{model_name} ||= mock_model(#{model_name.capitalize}).as_null_object).tap do |m|
      m.stub(stubs) unless stubs.empty?
    end
  end
  END_RUBY
  end
end

# to get default_url_options working in rspec, from: https://github.com/rspec/rspec-rails/issues/255
class ActionView::TestCase::TestController
  def default_url_options(options={})
    { :locale => I18n.locale }
  end
end

class ActionDispatch::Routing::RouteSet
  def default_url_options(options={})
    { :locale => I18n.locale }
  end
end
