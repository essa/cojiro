
require "bundler/capistrano"

set :application, "cojiro"
set :repository,  "git://github.com/essa/cojiro.git"
set :rails_env, "production"

set :scm, :git
set :branch,      'feature/deploy'

role :web, "localhost"                          # Your HTTP server, Apache/etc
role :app, "localhost"                          # This may be the same as your `Web` server
role :db,  "localhost", :primary => true # This is where Rails migrations will run

#set :public_children, []

set :default_environment, {
  'PATH' => "/home/admin/.rbenv/shims:/home/admin/.rbenv/bin:/home/admin/.nave/installed/bin/:$PATH"
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

