# Simplify running tests by automating most of the work using rake

require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

task :default => [:spec, :lint]
task :spec    => :test

RSpec::Core::RakeTask.new(:test) do |t|
    t.rspec_opts = '-O spec/spec.opts'
end
