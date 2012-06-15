require 'spec_helper'

describe "ethernet-test" do
    let(:facts) do {
        :operatingsystem => 'Debian',
        :hostname        => 'ethernet-test',
    } end

    iface = 'eth0'

    describe "services" do
        it do should contain_service('networking').with('hasrestart' => true) end
    end

    describe "options" do
        it do
            should contain_networking__iface__option("#{iface} address").with(
                'iface'  => iface,
                'option' => 'address',
                'value'  => '192.168.0.100'
            )
        end

        it do
            should contain_networking__iface__option("#{iface} netmask").with(
                'iface'  => iface,
                'option' => 'netmask',
                'value'  => '255.255.255.0'
            )
        end

        it do
            should contain_networking__iface__option("#{iface} broadcast").with(
                'iface'  => iface,
                'option' => 'broadcast',
                'value'  => '192.168.0.255'
            )
        end

        it do
            should contain_networking__iface__option("#{iface} gateway").with(
                'iface'  => iface,
                'option' => 'gateway',
                'value'  => '192.168.0.1'
            )
        end
    end

    describe "resources" do
        it do
            should contain_networking__iface__up("ethernet #{iface} up").with(
                'iface'  => iface,
                'really' => true
            )
        end

        it do
            should contain_networking__iface__auto(iface).with(
                'ensure' => 'present',
                'auto'   => true
            )
        end

        it do
            should contain_networking__iface__ethernet(iface).with(
                'address' => '192.168.0.100',
                'netmask' => '255.255.255.0',
                'gateway' => '192.168.0.1'
            )
        end

        it do
            should contain_networking__iface__configure("#{iface} create").with(
                'iface'  => iface,
                'method' => 'static',
                'up'     => false,
                'down'   => false
            )
        end
    end
end
