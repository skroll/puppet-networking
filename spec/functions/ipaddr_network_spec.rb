require 'spec_helper'

describe 'ipaddr_network' do
    tests = [
        { :ipaddr => '192.168.6.1',   :network => '255.255.255.0',   :out => '192.168.6.0', },
        { :ipaddr => '192.168.6.128', :network => '255.255.255.0',   :out => '192.168.6.0', },
        { :ipaddr => '192.168.6.254', :network => '255.255.255.224', :out => '192.168.6.224', },
        { :ipaddr => '192.168.6.181', :network => '255.255.255.224', :out => '192.168.6.160', },
    ]

    tests.each do |test|
       it "should return '#{test[:out]}' with input ('#{test[:ipaddr]}', '#{test[:network]}')" do
            should run.with_params(test[:ipaddr], test[:network]).and_return(test[:out])
        end
    end
end

