define networking::iface::up (
  $iface,
  $really = true
) {
  $noop = $really ? { true => false, false => true }

  exec { $name:
    command => "/sbin/ifup $iface && sleep 5",
    unless  => "/bin/grep -q '^$iface=' /var/run/network/ifstate",
    noop    => $noop
  }
}


