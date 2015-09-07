exec { 'clean apt lists':
	command => '/bin/rm /var/lib/apt/lists/* -vfr'
}
exec { 'apt-get update':
	command => '/usr/bin/apt-get update',
	require => Exec['clean apt lists']
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