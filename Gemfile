source 'https://rubygems.org'

gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', '~> 2.0.1', :branch => '2.0'
end

gem 'jquery-rails'
gem 'haml', ">= 3.1.alpha.50"
gem 'haml-rails'
gem 'globalize3', :git => 'git://github.com/svenfuchs/globalize3.git'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'twitter_bootstrap_form_for', :git => 'git://github.com/stouset/twitter_bootstrap_form_for.git', :branch => 'bootstrap-2.0'
gem 'carrierwave', :git => 'git://github.com/jnicklas/carrierwave.git'
gem 'mini_magick'

group :test, :development do
  gem 'rspec-rails'
  gem 'cucumber', '>= 1.1.6'
  gem 'spork', '~> 0.9.0.rc'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-webkit', :git => 'https://github.com/thoughtbot/capybara-webkit.git'
  gem 'debugger'
end

group :test do
  # ref: http://datacodescotch.blogspot.jp/2011/11/warning-cucumber-rails-required-outside.html 
  gem 'cucumber-rails', '~> 1.0', require: false
  gem 'webmock'
end
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'
