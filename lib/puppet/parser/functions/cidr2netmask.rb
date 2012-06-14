# cidr2netmask(BITS) -> NETMASK
#
# Convert a CIDR netmask to a dotted-decimal netmask.
#
# e.g.,
#   cidr2netmask(24) -> 255.255.255.0

require 'ipaddr'
Puppet::Parser::Functions.newfunction(:cidr2netmask, :type => :rvalue) do |args|
    IPAddr.new('255.255.255.255').mask(args[0].to_i).to_s
end
