require 'spec_helper'

describe 'ipaddr_broadcast' do
    tests = [
        { :ipaddr => '192.168.6.1',   :netmask => '255.255.255.0',   :out => '192.168.6.255' },
        { :ipaddr => '192.168.6.160', :netmask => '255.255.255.224', :out => '192.168.6.191' },
        { :ipaddr => '192.168.6.254', :netmask => '255.255.255.254', :out => '192.168.6.255' },
    ]

    tests.each do |test|
       it "should return '#{test[:out]}' with input ('#{test[:ipaddr]}', '#{test[:netmask]}')" do
            should run.with_params(test[:ipaddr], test[:netmask]).and_return(test[:out])
       end
    end
end

