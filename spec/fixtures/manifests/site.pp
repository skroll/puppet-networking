node default {
}

node 'ethernet-test' inherits default {
  networking::iface::ethernet { 'eth0':
    address => '192.168.0.100',
    netmask => '255.255.255.0',
    gateway => '192.168.0.1',
  }
}
