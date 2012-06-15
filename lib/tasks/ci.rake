require 'guard/jasmine/task'
Guard::JasmineTask.new

task :ci do
  Rake::Task['spec'].invoke
  Rake::Task['cucumber'].invoke
  Rake::Task['guard:jasmine'].invoke
end
