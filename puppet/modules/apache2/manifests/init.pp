class apache2 {
	package { 'apache2':
		ensure  => present,
		require => Exec['apt-get update'],
	}

	file { 'apache2 sites':
		path    => '/etc/apache2/sites-enabled',
		recurse => "remote",
		ensure  => file,
		require => Package['apache2'],
		source  => 'puppet:///modules/apache2/sites',
		notify  => Service['apache2'],
	}

	file { 'apache2 ports':
		path    => '/etc/apache2/ports.conf',
		recurse => "remote",
		ensure  => file,
		require => Package['apache2'],
		source  => 'puppet:///modules/apache2/ports.conf',
		notify  => Service['apache2'],
	}

	file { 'apache2 logs permissions':
		path    => '/var/log/apache2',
		mode    => 777
	}

	file { 'default-apache2-disable':
		path    => '/etc/apache2/sites-enabled/000-default.conf',
		ensure  => absent,
		require => Package['apache2'],
		notify  => Service['apache2'],
	}

	file { 'remove apache2 html folder':
		path    => '/var/www/html',
		ensure  => absent,
		force   => true,
		require => Package['apache2'],
		notify  => Service['apache2'],
	}

	service { 'apache2':
		ensure  => running,
		require => [
			Package['apache2'],
		]
	}
}