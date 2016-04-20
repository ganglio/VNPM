class apache2 {
	package { 'apache2':
		ensure  => present,
		require => Exec['apt-get update'],
		before  => Package['apache2-mpm-itk']
	}

	exec { 'apache2 fix mpm':
		command => '/usr/sbin/a2dismod mpm_event',
		require => Package['apache2'],
	}

	package { 'libapache2-mpm-itk':
		ensure  => present,
		require => [
			Package['apache2'],
			Exec['apache2 fix mpm'],
		],
		before  => Package['apache2-mpm-itk'],
	}

	package { 'apache2-mpm-itk':
		ensure  => present,
		require => Package['apache2'],
	}

	package { 'libapache2-mod-php5':
		ensure  => present,
		require => Package['apache2'],
		notify  => Service['apache2'],
	}

	file { 'apache2 ssl module':
		path    => '/etc/apache2/mods-enabled/ssl.load',
		ensure  => link,
		require => Package['apache2'],
		source  => '/etc/apache2/mods-available/ssl.load',
		notify  => Service['apache2'],
	}

	file { 'apache2 rewrite module':
		path    => '/etc/apache2/mods-enabled/rewrite.load',
		ensure  => link,
		require => Package['apache2'],
		source  => '/etc/apache2/mods-available/rewrite.load',
		notify  => Service['apache2'],
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