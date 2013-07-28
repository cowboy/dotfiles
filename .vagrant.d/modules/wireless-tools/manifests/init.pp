
class wireless-tools {
	require python-tools
  require hg

  $apt_packages = ['aircrack-ng', 'wireless-tools', 'iw', 'wireshark', 'net-tools']

  package { $apt_packages:
  	ensure => present,
  }

  python-tools::source-install { 'scapy':
    repo_url => 'http://hg.secdev.org/scapy',
    provider => 'hg',    
  }
}