define networking::iface::configure (
  $iface,
  $method  = 'dhcp',
  $family  = 'inet',
  $comment = false,
  $up      = true,
  $down    = false
) {
  exec { "$iface down-for-reconfigure":
    command => "/sbin/ifdown $iface || /bin/true",
    unless  => "/bin/egrep '^iface[[:space:]]+$iface[[:space:]]+\
$family[[:space:]]+$method' /etc/network/interfaces",
  }

  augeas { "$iface create":
    context => '/files/etc/network/interfaces',
    changes => [
      "set iface[last()+1]      $iface",
      "set iface[last()]/family $family",
      "set iface[last()]/method $method",
    ],
    onlyif  => "match iface[.=\"$iface\"] size == 0",
    notify  => Service['networking'],
    require => Exec["$iface down-for-reconfigure"],
  }

  if $comment {
    option { "$iface comment":
      iface   => $iface,
      option  => '#comment',
      value   => $comment,
      require => Augeas["$iface create"],
    }
  }

  augeas { "$iface options create":
    context => '/files/etc/network/interfaces',
    changes => [
      "set iface[.=\"$iface\"]/family $family",
      "set iface[.=\"$iface\"]/method $method",
    ],
    require => Augeas["$iface create"],
    notify  => Service['networking'],
  }

  if ($method == 'dhcp') {
    augeas { "$iface options delete":
      context => '/files/etc/network/interfaces',
      changes => [
        "rm iface[.=\"$iface\"]/address",
        "rm iface[.=\"$iface\"]/netmask",
        "rm iface[.=\"$iface\"]/broadcast",
        "rm iface[.=\"$iface\"]/gateway",
        "rm iface[.=\"$iface\"]/network",
      ],
      require => Augeas["$iface create"],
      before  => Up["$iface up"],
      norify  => Service['networking'],
    }
  }

  $really = $down ? { true => false, false => $up }

  up { "$iface up":
    iface   => $iface,
    really  => $really,
    require => Augeas["$iface options create"],
  }

  if $down {
    down { "$iface down":
      iface   => $iface,
      require => Up["$iface up"],
    }
  }
}

