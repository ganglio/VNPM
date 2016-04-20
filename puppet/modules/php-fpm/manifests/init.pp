class php-fpm {
	package { 'php5-fpm':
		ensure  => present,
		require => Exec['apt-get update'],
	}

	package { 'php5':
		ensure  => present,
		require => Exec['apt-get update'],
	}

	package { 'php5-dev':
		ensure  => present,
		require => Exec['apt-get update'],
	}

	package { 'php-pear':
		ensure  => present,
		require => Exec['apt-get update'],
	}

	file { 'www.conf':
		path    => '/etc/php5/fpm/pool.d/www.conf',
		ensure  => file,
		recurse => remote,
		source  => 'puppet:///modules/php-fpm/www.conf',
		notify  => Service['php5-fpm'],
	}

	service { 'php5-fpm':
		ensure  => running,
		require => Package['php5-fpm'],
	}
}