require 'rspec-puppet'

fixtures_path = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures')

RSpec.configure do |c|
    c.manifest_dir = File.join(fixtures_path, 'manifests')
    c.module_path = File.join(fixtures_path, 'modules')
end

