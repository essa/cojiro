source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :production do
  gem 'mysql2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'backbone-support'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', :branch => '2.0'
  gem 'execjs'
  gem 'i18n-js', :git => 'https://github.com/fnando/i18n-js.git'
end

gem 'jquery-rails'
gem 'haml', ">= 3.1.alpha.50"
gem 'haml-rails'
gem 'globalize3', :git => 'git://github.com/svenfuchs/globalize3.git'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'carrierwave', :git => 'git://github.com/jnicklas/carrierwave.git'
gem 'mini_magick'
gem 'journey', '1.0.4' # ref: https://github.com/rails/journey/issues/42

group :test, :development do
  gem 'rspec-rails'
  gem 'cucumber', '1.2.5'
  gem 'spork', '~> 0.9.0.rc'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-webkit', :git => 'https://github.com/thoughtbot/capybara-webkit.git', :require => false
  gem 'jasminerice', :git => 'https://github.com/bradphelan/jasminerice.git', :ref => '13ae61378afdf66aed7eb945172eb1f5c75b451b'
  gem 'rake'
  gem 'timecop'
  gem 'chronic'
  gem 'launchy'
  gem 'embedly'
  gem 'sqlite3'
  unless ENV['CI']
    gem 'pry'
    gem 'pry-debugger'
  end
end

group :test do
  # ref: http://datacodescotch.blogspot.jp/2011/11/warning-cucumber-rails-required-outside.html 
  # ref: http://stackoverflow.com/questions/16226933/run-cucumber-through-spork
  gem 'cucumber-rails', '1.3.0', :require => false
  gem 'webmock', '>= 1.9.0'
  gem 'vcr', '~> 2.5.0'
  gem 'shoulda-matchers'
  unless ENV['CI']
    gem 'guard', :git => 'git://github.com/guard/guard.git'
    gem 'rb-inotify', '>= 0.8.8'
    gem 'guard-spork'
    gem 'guard-rspec', :require => false
    gem 'guard-cucumber', :require => false
    gem 'guard-jasmine'
    gem 'guard-rails'
  end
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

unless ENV['CI']
  # Use unicorn as the web server
  gem 'unicorn', :require => false

  # Deploy with Capistrano
  gem 'capistrano', :require => false unless ENV['CI']
end

# Load require.js
gem 'requirejs-rails', :git => 'https://github.com/jwhitley/requirejs-rails.git'
