define networking::iface::ethernet (
  $address   = false,
  $netmask   = false,
  $broadcast = false,
  $gateway   = false,
  $dhcp      = true,
  $auto      = true,
  $up        = true,
  $down      = false,
  $ensure    = present
) {
  include networking::iface

  if ($ensure == "present") {
    if ($address) {
      if (!$netmask) {
        if ipaddr_network($address, $networking_netmask) == $networking_network {
          $_netmask = $networking_netmask
        }
        else {
          fail("must specify a netmask")
        }
      }
      else {
        $_netmask = $netmask
      }

      $_broadcast = $broadcast ? {
        false   => ipaddr_broadcast($address, $_netmask),
        default => $broadcast,
      }

      configure { "$name create":
        iface  => $name,
        method => "static",
        up     => false,
        down   => $down,
      }

      Networking::Iface::Option {
        iface   => $name,
        require => Configure["$name create"],
        before  => Up["ethernet $name up"],
      }

      option {
        "$name address":
          option => "address",
          value  => $address;
        "$name netmask":
          option => "netmask",
          value  => $_netmask;
        "$name broadcast":
          option => "broadcast",
          value  => $_broadcast;
      }

      if ($gateway) {
        option { "$name gateway":
          option => "gateway",
          value  => $gateway,
        }
      }

      up { "ethernet $name up":
        iface  => $name,
        really => $down ? { true => false, false => $up},
      }
    }
    else {
      $method = $dhcp ? {
        true    => "dhcp",
        default => "manual",
      }

      configure { "$name create":
        iface  => $name,
        method => $method,
        up     => $up,
      }
    }
  }
  else {
    delete { "$name delete":
      iface => $name,
    }
  }

  auto { "$name":
    ensure => $ensure,
    auto   => $auto,
  }
}
