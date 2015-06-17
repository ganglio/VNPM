exec { 'apt-get update':
	command => '/usr/bin/apt-get update',
}

package { 'vim':
	ensure  => present,
	require => Exec['apt-get update'],
}

package { 'make':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'language-pack-en':
	ensure => present,
	require => Exec['apt-get update'],
}