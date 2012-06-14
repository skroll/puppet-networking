# netmask2cidr(NETMASK) -> BITS
#
# Convert a dotted-decimal netmask into a CIDR netmask.
#
# e.g.,
#   netmask2cidr(255.255.255.0) -> 24

require 'ipaddr'
Puppet::Parser::Functions.newfunction(:netmask2cidr, :type => :rvalue) do |args|
    i = 0
    while ((IPAddr.new(args[0]) & IPAddr.new("255.255.255.255")) << i).to_i > 0
        i += 1
    end
    i
end
