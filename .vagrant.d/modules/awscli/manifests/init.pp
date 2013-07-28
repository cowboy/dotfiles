# Class: awscli
#
# This class installs awscli
#
# Actions:
#   - Install the awscli package using pip
#   - Install Python boto package using pip
#   - Install s3cmd tool
#
# Sample Usage:
#  class { 'awscli': }
#
class awscli {
  require python-tools

  # s3cmd and a config file for it
  package { 's3cmd':
  	ensure => present,
  }

  file { "/home/vagrant/.s3cfg":
    content => template('awscli/s3cfg'),
    mode => '700',
    owner => 'vagrant',
    group => 'vagrant',
  }
  file { "/home/vagrant/.boto":
    content => template('awscli/boto'),
    mode => '700',
    owner => 'vagrant',
    group => 'vagrant',
  }  

  python-tools::source-install { 'boto':
    repo_url => 'https://github.com/ivanlei/boto.git',
    repo_name => 'boto', 
  }
}