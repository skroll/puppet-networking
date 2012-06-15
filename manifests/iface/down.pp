define networking::iface::down (
  $iface
) {
  exec { $name:
    command => "/sbin/ifdown $iface",
    onlyif  => "/bin/grep -q '^$iface=' /var/run/network/ifstate",
  }
}
