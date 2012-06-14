class networking::iface {
  include networking

  service { 'networking':
    hasrestart => true,
    status     => '/bin/true',
  }

  define auto (
    $auto  = true,
    $ensure = present,
  ) {
    if ($auto == true) and ($ensure == "present") {
      augeas { "$name on":
        context => "/files/etc/network/interfaces",
        changes => [
          "set auto[last()+1]/1 $name",
        ],
        onlyif => "match auto[*]/*[.=\"$name\"] size == 0",
        before => Augeas["$name create"]
      }
    }
    else {
      augeas { "$name off":
        context => "/files/etc/network/interfaces",
        changes => [
          "rm auto[*]/*[.=\"$name\"]",
          "rm auto[count(*)=0]",
        ],
        onlyif => "match auto[*]/*[.=\"$name\"] size > 0",
      }
    }
  }

  define configure (
    $iface,
    $method  = "dhcp",
    $family  = "inet",
    $comment = false,
    $up      = true,
    $down    = false
  ) {
    exec { "$iface down-for-reconfigure":
      command => "/sbin/ifdown $iface || /bin/true",
      unless  => "/bin/egrep '^iface[[:space:]]+$iface[[:space:]]+$family[[:space:]]+$method' /etc/network/interfaces",
    }

    augeas { "$iface create":
      context => "/files/etc/network/interfaces",
      changes => [
        "set iface[last()+1]      $iface",
        "set iface[last()]/family $family",
        "set iface[last()]/method $method",
      ],
      onlyif  => "match iface[.=\"$iface\"] size == 0",
      notify  => Service["networking"],
      require => Exec["$iface down-for-reconfigure"],
    }

    if $comment {
      option { "$iface comment":
        iface   => $iface,
        option  => "#comment",
        value   => $comment,
        require => Augeas["$iface create"],
      }
    }

    augeas { "$iface options create":
      context => "/files/etc/network/interfaces",
      changes => [
        "set iface[.=\"$iface\"]/family $family",
        "set iface[.=\"$iface\"]/method $method",
      ],
      require => Augeas["$iface create"],
      notify  => Service["networking"],
    }

    if ($method == "dhcp") {
      augeas { "$iface options delete":
        context => "/files/etc/network/interfaces",
        changes => [
          "rm iface[.=\"$iface\"]/address",
          "rm iface[.=\"$iface\"]/netmask",
          "rm iface[.=\"$iface\"]/broadcast",
          "rm iface[.=\"$iface\"]/gateway",
          "rm iface[.=\"$iface\"]/network",
        ],
        require => Augeas["$iface create"],
        before  => Up["$iface up"],
        norify  => Service["networking"],
      }
    }

    up { "$iface up":
      iface => $iface,
      really => $down ? { true => false, false => $up },
      require => [
        Augeas["$iface options create"],
      ],
    }

    if $down {
      down { "$iface down":
        iface => $iface,
        require => Up["$iface up"],
      }
    }
  }

  define up (
    $iface,
    $really = true
  ) {
    exec { $name:
      command => "/sbin/ifup $iface && sleep 5",
      unless  => "/bin/grep -q '^$iface=' /var/run/network/ifstate",
      noop    => $really ? { true => false, false => true },
    }
  }

  define down (
    $iface
  ) {
    exec { $name:
      command => "/sbin/ifdown $iface",
      onlyif  => "/bin/grep -q '^$iface=' /var/run/network/ifstate",
    }
  }

  define delete (
    $iface
  ) {
    augeas { "$iface delete":
      context => "/files/etc/network/interfaces",
      changes => [
        "rm iface[.=\"$iface\"]",
      ],
      onlyif  => "match iface[.=\"$iface\"] size > 0",
      require => Exec["$iface down"],
      notify  => Service["networking"],
    }

    exec { "$iface down":
      command => "/sbin/ifdown $iface",
      onlyif  => "/bin/grep -q '^$iface=' /var/run/network/ifstate",
    }
  }

  define option (
    $iface,
    $option,
    $value  = "",
    $multi  = false,
    $ensure = present,
  ) {
    if $ensure == "present" {
      if $multi {
        augeas { "$iface option $option $value":
          context => "/files/etc/network/interfaces",
          changes => [
            "set iface[.=\"$iface\"]/$option[last()+1] \"$value\"",
          ],
          onlyif  => "match iface[.=\"$iface\"]/$option[.=\"$value\"] size == 0",
          notify  => Service["networking"],
        }
      }
      else {
        augeas { "$iface option $option":
          context => "/files/etc/network/interfaces",
          changes => [
            "set iface[.=\"$iface\"]/$option \"$value\"",
          ],
          onlyif  => "match iface[.=\"$iface\"] size > 0",
          notify  => Service["networking"],
        }
      }
    }
    else {
      if $multi {
        augeas { "$iface delete $option $value":
          context => "/files/etc/network/interfaces",
          changes => [
            "rm iface[.=\"$iface\"]/$option[.=\"$value\"]",
          ],
          onlyif  => "match iface[.=\"$iface\"]/$option[.=\"$value\"] size > 0",
          notify  => Service["networking"],
        }
      }
      else {
        augeas { "$iface delete $option":
          context => "/files/etc/network/interfaces",
          changes => [
            "rm iface[.=\"$iface\"]/$option"
          ],
          onlyif  => "match iface[.=\"$iface\"]/$option size > 0",
          notify  => Service["networking"],
        }
      }
    }
  }

  define loopback {
    configure { "lo":
      method => "loopback",
    }
  }
}
