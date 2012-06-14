# ipaddr_broadcast(IPADDR, NETMASK) -> BROADCAST
#
# Convert an IP address and a netmask to a broadcast address.
#
# e.g.,
#   ipaddr_broadcast(192.168.6.1, 255.255.255.0) -> 192.168.6.255

require 'ipaddr'
Puppet::Parser::Functions.newfunction(:ipaddr_broadcast, :type => :rvalue) do |args|
    return (IPAddr.new(args[0]) | ~IPAddr.new(args[1])).to_s
end
