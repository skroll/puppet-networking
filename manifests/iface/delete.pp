define networking::iface::delete (
  $iface
) {
  augeas { "$iface delete":
    context => '/files/etc/network/interfaces',
    changes => [
      "rm iface[.=\"$iface\"]",
    ],
    onlyif  => "match iface[.=\"$iface\"] size > 0",
    require => Exec["$iface down"],
    notify  => Service['networking'],
  }

  exec { "$iface down":
    command => "/sbin/ifdown $iface",
    onlyif  => "/bin/grep -q '^$iface=' /var/run/network/ifstate",
  }
}


