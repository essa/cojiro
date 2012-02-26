Cojiro::Application.config.base_languages = [:ja, :en]

if (ENV["RAILS_ENV"] == 'test' || ENV["RAILS_ENV"] == 'development')

  # to get default_url_options working in rspec & cucumber, from: https://github.com/rspec/rspec-rails/issues/255
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

end
