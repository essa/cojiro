task :travis do
  FileUtils.cp "config/database_travis.yml", 'config/database.yml'
  Rake::Task["db:migrate"].invoke
  ["rspec -f d --color spec", "rake cucumber", "guard-jasmine"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end
