set :application, "cojiro"
set :repository,  "git://github.com/essa/cojiro.git"

set :scm, :git
set :branch,      'feature/deploy'

role :web, "dev1.brainosr.net"                          # Your HTTP server, Apache/etc
role :app, "dev1.brainosr.net"                          # This may be the same as your `Web` server
role :db,  "dev1.brainosr.net", :primary => true # This is where Rails migrations will run

set :public_children, []

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