# Class: python-tools
#
# This class installs python-tools
#
# Actions:
#   - Install the python-pip package
#   - Install the virtualenv package using pip
#   - Install the python3 package
#   - Install the pudb package
#   - Install the ipython package
#
# Sample Usage:
#  class { 'python-pip': }
#
class python-tools {
  $prereqs = ['build-essential', "linux-headers-$kernelrelease", 'python-dev']

  package { $prereqs:
  	ensure => present,
  }

  package { 'python-pip':
    ensure => present,
    require => Package[$prereqs]
  }

  package { ['pudb, virtualenv','simplejson','xmltodict', 'keyring']:
    ensure => present,
    provider => 'pip',
    require => Package['python-pip']
  }  

  package { 'python3':
  	ensure => present
  }

  package { 'ipython':
  	ensure => present
  }

  python-tools::source-install { 'keyczar':
    repo_url => 'https://code.google.com/p/keyczar',
    repo_name => 'keyczar',
    install_path => 'python',    
  }
}