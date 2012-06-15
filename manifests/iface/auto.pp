define networking::iface::auto (
  $auto  = true,
  $ensure = present,
) {
  if ($auto == true) and ($ensure == 'present') {
    augeas { "$name on":
      context => '/files/etc/network/interfaces',
      changes => [
        "set auto[last()+1]/1 $name",
      ],
      onlyif => "match auto[*]/*[.=\"$name\"] size == 0",
      before => Augeas["$name create"]
    }
  }
  else {
    augeas { "$name off":
      context => '/files/etc/network/interfaces',
      changes => [
        "rm auto[*]/*[.=\"$name\"]",
        'rm auto[count(*)=0]',
      ],
      onlyif => "match auto[*]/*[.=\"$name\"] size > 0",
    }
  }
}

