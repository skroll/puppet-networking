require 'spec_helper'

describe 'networking' do
    let(:title) { 'networking.testing' }

    context "on Debian operating systems" do
        let(:facts) { { :operatingsystem => "Debian" } }

        it { should include_class('networking::defaults::packages::debian') }
    end
end
