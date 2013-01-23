source 'https://rubygems.org'

gem 'rails', '3.2.6'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

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
  gem 'bootstrap-sass', '~> 2.0.1', :branch => '2.0'
  gem 'haml_coffee_assets', '~> 1.11.0'
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
gem 'journey', '1.0.3' # ref: https://github.com/rails/journey/issues/42

group :test, :development do
  gem 'rspec-rails'
  gem 'cucumber', '>= 1.1.6'
  gem 'spork', '~> 0.9.0.rc'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-webkit', :git => 'https://github.com/thoughtbot/capybara-webkit.git'
  gem 'jasmine'
  gem 'jasminerice'
  gem 'debugger' unless ENV['CI']
  gem 'rake'
  gem 'timecop'
  gem 'chronic'
  gem 'launchy'
  gem 'sqlite3'
end

group :test do
  # ref: http://datacodescotch.blogspot.jp/2011/11/warning-cucumber-rails-required-outside.html 
  gem 'cucumber-rails', '~> 1.0', require: false
  gem 'webmock'
  gem 'guard', '>= 1.3.2'
  gem 'rb-inotify', '~> 0.8.8'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-jasmine'
  gem 'guard-rails'
  gem 'guard-livereload'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# Load require.js
gem 'requirejs-rails', :git => 'https://github.com/jwhitley/requirejs-rails.git'
