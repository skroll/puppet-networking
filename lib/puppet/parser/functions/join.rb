# join(STRING, STRING...) : STRING

Puppet::Parser::Functions.newfunction(:join, :type => :rvalue) do |args|
    args.flatten!
    s = args.shift
    args.join(s)
end
