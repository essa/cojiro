require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'webmock/rspec'
  require 'vcr'
  require 'capybara/rspec'
  require 'capybara/rails'
  require 'capybara/webkit'
  require 'database_cleaner'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  Capybara.javascript_driver = :webkit

  # need to set this high to allow for time to load assets in request specs
  Capybara.default_wait_time = 15

  # to speed up tests: http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
  Rails.logger.level = 4

  RSpec.configure do |config|
    include CojiroRequestStubs
    include Helpers

    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.tty = true

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # for testing sign-in through Twitter, Facebook, etc.
    OmniAuth.config.test_mode = true

    # needed to avoid conflicts with capyabara for tests where :js => true
    WebMock.disable_net_connect!(:allow_localhost => true)

    VCR.configure do |c|
      c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
      c.allow_http_connections_when_no_cassette = true
      c.hook_into :webmock
      # ignore api key
      c.default_cassette_options = {
        :match_requests_on => [ :method, VCR.request_matchers.uri_without_param(:key)]
      }
    end

    # ref: https://github.com/vcr/vcr/issues/146
    VCR.turn_off!

    # Turns VCR on then off around the VCR.use_cassette block
    VCR.extend Module.new {
      def use_cassette(*args)
        VCR.turn_on!
        super
        VCR.turn_off!
      end
    }

    config.before(:each) do
      load_request_stubs unless VCR.turned_on?
    end

    # ref: http://highgroove.com/articles/2012/04/06/sane-rspec-config-for-clean,-and-slightly-faster,-specs.html
    config.before :suite do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    # Request specs cannot use a transaction because Capybara runs in a
    # separate thread with a different database connection.
    config.before type: :request do
      DatabaseCleaner.strategy = :truncation
    end

    config.before do
      DatabaseCleaner.start
    end

    config.after do
      DatabaseCleaner.clean
    end

    config.after(:all) do
      if Rails.env.test?
        FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
      end
    end 

    if defined?(CarrierWave)
      AvatarUploader # load AvatarUploader class 
      CarrierWave::Uploader::Base.descendants.each do |klass|
        next if klass.anonymous?
        klass.class_eval do
          def cache_dir_with_test_env
            "#{Rails.root}/spec/support/uploads/tmp"
          end

          def store_dir_with_test_env
            "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
          end

          alias_method_chain :cache_dir, :test_env
          alias_method_chain :store_dir, :test_env
        end
      end
    end

  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.
