# Simplify running tests by automating most of the work using rake

require 'rake'
require 'rspec/core/rake_task'

task :default => :test
task :spec    => :test

RSpec::Core::RakeTask.new(:test) do |t|
    t.rspec_opts = '-c -f documentation'
end

