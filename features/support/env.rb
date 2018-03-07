$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'suse/connect'
require 'aruba/cucumber'
require 'cucumber/rspec/doubles'

Aruba.configure do |config|
  config.activate_announcer_on_command_failure = [:stderr, :stdout, :command]
  config.startup_wait_time = 5
end

OPTIONS = YAML.load_file(File.join(__dir__, 'environments.yml')).fetch(ENV.fetch('PRODUCT'))

Before('@slow_process') do
  aruba.config.io_wait_timeout = 90
  aruba.config.exit_timeout = 90
end

Before('@libzypplocked') do
  `echo $PPID > /var/run/zypp.pid`
end

After('@libzypplocked') do
  `rm /var/run/zypp.pid`
end

Before('@skip-sles-15') do
  skip_this_scenario if base_product_version =~ /15/
end

Before('@skip-sles-12') do
  skip_this_scenario if base_product_version =~ /12/
end
