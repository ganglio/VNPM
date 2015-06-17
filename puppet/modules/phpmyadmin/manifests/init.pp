class phpmyadmin {

	package { 'php5-mysql':
		ensure  => present,
		require => [
			Exec['apt-get update'],
			Package['php5-fpm'],
			Package['mysql-server'],
		],
	}

	package { 'phpmyadmin':
		ensure  => present,
		require => [
			Exec['apt-get update'],
			Package['php5-fpm'],
			Package['php5-mysql'],
			Package['mysql-server'],
		],
	}

	file { 'phpmyadmin-config':
		path    => '/etc/phpmyadmin/config.inc.php',
		ensure  => file,
		replace => true,
		require => [
			Package['nginx'],
			Package['php5-fpm'],
			Package['phpmyadmin'],
		],
		source => 'puppet:///modules/phpmyadmin/config.inc.php',
		notify => Service['php5-fpm'],
	}
}