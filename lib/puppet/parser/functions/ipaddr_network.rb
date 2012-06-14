# ipaddr_network(IPADDR, NETMASK) -> NETWORK
#
# Convert an IP address and a netmask into a network address.
#
# e.g.,
#   ipaddr_network(192.168.6.1, 255.255.255.0) -> 192.168.6.0

require 'ipaddr'
Puppet::Parser::Functions.newfunction(:ipaddr_network, :type => :rvalue) do |args|
    return (IPAddr.new(args[0]) & IPAddr.new(args[1])).to_s
end
