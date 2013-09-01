
require "bundler/capistrano"

set :application, "cojiro"
set :repository,  "git://github.com/netalab/cojiro.git"
set :rails_env, "production"

set :scm, :git
set :branch,      'master'

set :uploads_dirs, %w(public/uploads)
set :shared_children, fetch(:shared_children) + fetch(:uploads_dirs)

role :web, "localhost"                          # Your HTTP server, Apache/etc
role :app, "localhost"                          # This may be the same as your `Web` server
role :db,  "localhost", :primary => true # This is where Rails migrations will run

#set :public_children, []

load File::join(ENV['HOME'], ".twitter_secret")
load File::join(ENV['HOME'], ".embedly_key")
set :default_environment, {
  'PATH' => "/home/admin/.rbenv/shims:/home/admin/.rbenv/bin:/home/admin/.nave/installed/bin/:$PATH",
  'TWITTER_KEY' =>  TWITTER_KEY,
  'TWITTER_SECRET' => TWITTER_SECRET,
  'EMBEDLY_KEY' => EMBEDLY_KEY
}

# It should be [:development, :test],but it did not work saying guard/jasmine/task not found
set :bundle_without,  []

set :config_files, %w(database.yml)

after "deploy:finalize_update", :role => [:app] do
  config_files.each do |file|
    run "cp #{shared_path}/config/#{file} #{release_path}/config/#{file}"
  end
end

set :unicorn_pid, "tmp/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path}; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
  end
  task :restart, :roles => :app do
    if File.exist? "#{current_path}/#{unicorn_pid}"
      run "kill -s USR2 `cat #{current_path}/#{unicorn_pid}`"
    end
  end
  task :stop, :roles => :app do
    run "kill -s QUIT `cat #{current_path}/#{unicorn_pid}`"
  end
end
