# iprandchoice(VALUE...)
#
# Choose pseudo-randomly between arguments, based on hash of ipaddress fact.
#
# e.g.,
#   iprandchoice(192.168.6.1, 192.168.6.2) -> 192.168.6.1 or 192.168.6.2

require 'ipaddr'
require 'digest/md5'
Puppet::Parser::Functions.newfunction(:iprandchoice, :type => :rvalue) do |args|
    hash = Digest::MD5.hexdigest(IPAddr.new(lookupvar('ipaddress')).to_s)
    args.flatten!
    return args[hash.to_i(base=16) % args.length]
end
