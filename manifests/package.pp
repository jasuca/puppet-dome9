# Class: dome9::package
#
# This module manages Dome9 package installation
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class dome9::package (
  $pairkey = undef,
  $domegroups = "",
) {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  if ($pairkey == undef) {
    fail('You must specify a pairkey')
  }

  exec {'install dome9 repository':
    command => '/bin/rpm -Uvh http://repository.dome9.com/centos/5/noarch/dome9-0.1.0-1.noarch.rpm > /dev/null',
    creates => '/etc/yum.repos.d/Dome9.repo'
  }

  package {'Dome9Agent':
    ensure => 'present',
    require => Exec['install dome9 repository'],
    notify => Exec['pairkey']
  }

  exec { 'pairkey':
    command     => "dome9d pair -k ${pairkey} -g '${domegroups}'",
    refreshonly => true
  }
}