class php-fpm {
	package { 'php5-fpm':
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

	service { 'php5-fpm':
		ensure  => running,
		require => Package['php5-fpm'],
	}
}