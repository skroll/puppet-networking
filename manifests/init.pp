# Class: networking
#
# This module manages networking
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class networking (
  $packages = undef,
) {
  if $packages == undef {
    case $::operatingsystem {
      darwin: {
        # There are no darwin packages required
      }
      debian: {
        include networking::defaults::packages::debian
      }
      ubuntu: {
        include networking::defaults::packages::debian
      }
      default: {
        fail("Don't know how to handle networking packages on \
              ${::operatingsystem}")
      }
    }
  }
  else {
    package { $packages:
      ensure => present,
    }
  }
}
