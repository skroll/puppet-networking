# ipaddr_lastoctet(IPADDR) -> OCTET
#
# Fetch the last octet of an IP address.
#
# e.g.,
#   ipaddr_lastoctet(192.168.6.123) -> 123

require 'ipaddr'
Puppet::Parser::Functions.newfunction(:ipaddr_lastoctet, :type => :rvalue) do |args|
    return (IPAddr.new(args[0]).to_i & 255).to_s
end
