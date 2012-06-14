# This fact gets the default networking interface for the system.

Facter.add("default_if") do
    confine :kernel => :linux
    setcode do
        return nil unless FileTest.exists?("/sbin/ip")
        output = %x{/sbin/ip route list match 0.0.0.0}.chomp
        output.sub(/.*\s*dev\s+([^\s]+)\s*.*/, '\1')
    end
end

