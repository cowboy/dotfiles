define python-tools::source-install( 
	$repo_url,
	$repo_name = $name,
	$install_path = '',
	$provider = 'git',
	) 
{
  vcsrepo { "/tmp/${repo_name}":
    ensure => present,
    provider => $provider,
    source => $repo_url,
    require => Class[$provider],
  } ->
  exec { "install_${repo_name}":
    command => "sudo python setup.py install",
    cwd => "/tmp/${repo_name}/${install_path}",
    path => ["/usr/bin", "/usr/sbin"],
  } ->
  file { "/tmp/${repo_name}":
  	ensure => absent,
  	force => true,
	}
}