
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
  'PATH' => "/home/admin/.rbenv/shims:/home/admin/.rbenv/bin:$PATH"
}

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

set :config_files, %w(database.yml)

after "deploy:update_code", :role => [:app] do
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

