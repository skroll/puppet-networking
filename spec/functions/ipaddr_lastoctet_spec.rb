require 'spec_helper'

describe 'ipaddr_lastoctet' do
    tests = [
        { :in => '192.168.6.1',   :out => '1',   },
        { :in => '192.168.6.128', :out => '128', },
        { :in => '192.168.6.254', :out => '254', },
    ]

    tests.each do |test|
       it "should return '%s' with input '%s'" % [test[:out], test[:in]] do
            should run.with_params(test[:in]).and_return(test[:out])
        end
    end
end

