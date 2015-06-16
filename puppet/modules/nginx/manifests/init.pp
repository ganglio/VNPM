class nginx {
	package { 'nginx':
		ensure  => present,
		require => Exec['apt-get update'],
	}

	file { 'vagrant sites':
		path    => '/etc/nginx/sites-enabled',
		ensure  => directory,
		replace => true,
		require => Package['nginx'],
		source  => 'puppet:///modules/nginx/sites',
		notify  => Service['nginx'],
	}

	file { 'vagrant-certs':
		path    => '/etc/nginx/certs',
		ensure  => file,
		recurse => remote,
		source  => 'puppet:///modules/nginx/certs',
		notify  => Service['nginx'],
	}

	file { 'default-nginx-disable':
		path    => '/etc/nginx/sites-enabled/default',
		ensure  => absent,
		require => Package['nginx'],
		notify  => Service['nginx'],
	}

	service { 'nginx':
		ensure  => running,
		require => Package['nginx'],
	}
}