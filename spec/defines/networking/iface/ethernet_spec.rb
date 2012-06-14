require 'spec_helper'

describe 'networking::iface::ethernet' do
    $iface = 'eth0'

    for $operatingsystem in ['Debian'] do
        context "on operatingsystem %s for interface %s" % [$operatingsystem, $iface] do
            let(:facts) { { :operatingsystem => $operatingsystem } }
            let(:title) { 'eth0' }

            context "with address = '192.168.0.10', netmask = '255.255.255.0', gateway = '192.168.0.1'" do
                let(:params) do {
                    :address => "192.168.0.10",
                    :netmask => "255.255.255.0",
                    :gateway => "192.168.0.1",
                } end

                it do should contain_networking__iface__configure("%s create" % $iface).with(
                    'iface'  => $iface,
                    'method' => 'static',
                    'up'     => false,
                    'down'   => false
                ) end

                it do should contain_networking__iface__option('%s address' % $iface).with(
                    'option' => 'address',
                    'value'  => '192.168.0.10'
                ) end

                it do should contain_networking__iface__option('%s netmask' % $iface).with(
                    'option' => 'netmask',
                    'value'  => '255.255.255.0'
                ) end

                it do should contain_networking__iface__option('%s broadcast' % $iface).with(
                    'option' => 'broadcast',
                    'value'  => '192.168.0.255'
                ) end

                it do should contain_networking__iface__up('ethernet %s up' % $iface).with(
                    'iface'  => $iface,
                    'really' => true
                ) end

                it do should contain_networking__iface__auto($iface).with(
                    'ensure' => 'present',
                    'auto'   => true
                ) end

                it do should contain_augeas('%s on' % $iface) end
            end
        end
    end
end

