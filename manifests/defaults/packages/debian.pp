class networking::defaults::packages::debian {
  package { ['netbase', 'ethtool', 'iproute', 'iputils-ping', 'traceroute']:
    ensure => present,
  }
}
