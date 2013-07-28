# Class: virtualenv
#
# This class installs virtualenv
#
# Actions:
#   - Install the virtualenv package using pip
#
# Sample Usage:
#  class { 'virtualenv': }
#
class virtualenv {
  require python-pip

  package { 'virtualenv':
    ensure => present,
    provider => 'pip'
  }
}