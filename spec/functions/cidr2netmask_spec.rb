require 'spec_helper'

describe 'cidr2netmask' do
    tests = [
        { :in => '32', :out => '255.255.255.255' },
        { :in => '31', :out => '255.255.255.254' },
        { :in => '30', :out => '255.255.255.252' },
        { :in => '29', :out => '255.255.255.248' },
        { :in => '28', :out => '255.255.255.240' },
        { :in => '27', :out => '255.255.255.224' },
        { :in => '26', :out => '255.255.255.192' },
        { :in => '25', :out => '255.255.255.128' },

        { :in => '24', :out => '255.255.255.0' },
        { :in => '23', :out => '255.255.254.0' },
        { :in => '22', :out => '255.255.252.0' },
        { :in => '21', :out => '255.255.248.0' },
        { :in => '20', :out => '255.255.240.0' },
        { :in => '19', :out => '255.255.224.0' },
        { :in => '18', :out => '255.255.192.0' },
        { :in => '17', :out => '255.255.128.0' },

        { :in => '16', :out => '255.255.0.0' },
        { :in => '15', :out => '255.254.0.0' },
        { :in => '14', :out => '255.252.0.0' },
        { :in => '13', :out => '255.248.0.0' },
        { :in => '12', :out => '255.240.0.0' },
        { :in => '11', :out => '255.224.0.0' },
        { :in => '10', :out => '255.192.0.0' },
        { :in => '9',  :out => '255.128.0.0' },

        { :in => '8',  :out => '255.0.0.0' },
        { :in => '7',  :out => '254.0.0.0' },
        { :in => '6',  :out => '252.0.0.0' },
        { :in => '5',  :out => '248.0.0.0' },
        { :in => '4',  :out => '240.0.0.0' },
        { :in => '3',  :out => '224.0.0.0' },
        { :in => '2',  :out => '192.0.0.0' },
        { :in => '1',  :out => '128.0.0.0' },

        { :in => '0',  :out => '0.0.0.0' },
    ]

    tests.each do |test|
        it "should return '#{test[:out]}' with input '#{test[:in]}'" do
            should run.with_params(test[:in]).and_return(test[:out])
        end
    end
end
