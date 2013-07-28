# Class: hg
#
# This class installs mercurial source control
#
# Sample Usage:
#  class { 'hg': }
#
class hg {
	package { 'mercurial':
		ensure => present,
	}
}