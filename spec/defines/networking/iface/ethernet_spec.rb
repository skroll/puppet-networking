require 'spec_helper'

describe 'networking::iface::ethernet' do
    iface = 'eth0'

    ['Debian'].each do |operatingsystem|
        context "on operatingsystem #{operatingsystem} for interface #{iface}" do
            let(:facts) { { :operatingsystem => operatingsystem } }
            let(:title) { iface }

            context "with address = '192.168.0.10', netmask = '255.255.255.0', gateway = '192.168.0.1'" do
                let(:params) do {
                    :address => "192.168.0.10",
                    :netmask => "255.255.255.0",
                    :gateway => "192.168.0.1",
                } end

                it do should contain_networking__iface__configure("#{iface} create").with(
                    'iface'  => iface,
                    'method' => 'static',
                    'up'     => false,
                    'down'   => false
                ) end

                it do should contain_networking__iface__option("#{iface} address").with(
                    'option' => 'address',
                    'value'  => '192.168.0.10'
                ) end

                it do should contain_networking__iface__option("#{iface} netmask").with(
                    'option' => 'netmask',
                    'value'  => '255.255.255.0'
                ) end

                it do should contain_networking__iface__option("#{iface} broadcast").with(
                    'option' => 'broadcast',
                    'value'  => '192.168.0.255'
                ) end

                it do should contain_networking__iface__up("ethernet #{iface} up").with(
                    'iface'  => iface,
                    'really' => true
                ) end

                it do should contain_networking__iface__auto(iface).with(
                    'ensure' => 'present',
                    'auto'   => true
                ) end

                it do should contain_augeas("#{iface} on") end
            end
        end
    end
end

