define networking::iface::option (
  $iface,
  $option,
  $value  = '',
  $multi  = false,
  $ensure = present,
) {
  if $ensure == 'present' {
    if $multi {
      augeas { "$iface option $option $value":
        context => '/files/etc/network/interfaces',
        changes => [
          "set iface[.=\"$iface\"]/$option[last()+1] \"$value\"",
        ],
        onlyif  => "match iface[.=\"$iface\"]/$option[.=\"$value\"] size == 0",
        notify  => Service['networking'],
      }
    }
    else {
      augeas { "$iface option $option":
        context => '/files/etc/network/interfaces',
        changes => [
          "set iface[.=\"$iface\"]/$option \"$value\"",
        ],
        onlyif  => "match iface[.=\"$iface\"] size > 0",
        notify  => Service['networking'],
      }
    }
  }
  else {
    if $multi {
      augeas { "$iface delete $option $value":
        context => '/files/etc/network/interfaces',
        changes => [
          "rm iface[.=\"$iface\"]/$option[.=\"$value\"]",
        ],
        onlyif  => "match iface[.=\"$iface\"]/$option[.=\"$value\"] size > 0",
        notify  => Service['networking'],
      }
    }
    else {
      augeas { "$iface delete $option":
        context => '/files/etc/network/interfaces',
        changes => [
          "rm iface[.=\"$iface\"]/$option"
        ],
        onlyif  => "match iface[.=\"$iface\"]/$option size > 0",
        notify  => Service['networking'],
      }
    }
  }
}


