class networking::iface {
  include networking

  service { 'networking':
    hasrestart => true,
    status     => '/bin/true',
  }
}

