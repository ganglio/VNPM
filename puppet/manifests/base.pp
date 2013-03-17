group { 'puppet':
	ensure => present,
}

exec { 'apt-get update':
	command => '/usr/bin/apt-get update',
}

# Let's install some packages

package { 'vim':
	ensure  => present,
	require => Exec['apt-get update'],
}

package { 'nginx': 
	ensure  => present,
	require => Exec['apt-get update'],
}

package { 'mysql-server':
	ensure  => present,
	require => Exec['apt-get update'],
}

package { 'php5-fpm':
	ensure  => present,
	require => Exec['apt-get update'],
}

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

# Let's start some services

service { 'nginx':
	ensure  => running,
	require => Package['nginx'],
}

service { 'mysql':
	ensure  => running,
	require => Package['mysql-server'],
}

service { 'php5-fpm':
	ensure  => running,
	require => Package['php5-fpm'],
}

# And now we configure

exec { "create-db-user":
	unless  => "/usr/bin/mysqladmin -uvagrant -pvagrant status",
	command => "/usr/bin/mysql -uroot -p -e \"create user vagrant@'localhost' identified by 'vagrant'; grant all on *.* to vagrant@'localhost'; flush privileges;\"",
	require => Service["mysql"],
}

file { 'vagrant-nginx':
	path    => '/etc/nginx/sites-available/vagrant',
	ensure  => file,
	replace => true,
	require => Package['nginx'],
	source  => 'puppet:///modules/nginx/vagrant',
	notify  => Service['nginx'],
}

file { 'phpmyadmin-config':
	path    => '/usr/share/phpmyadmin/config.inc.php',
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


file { 'default-nginx-disable':
	path    => '/etc/nginx/sites-enabled/default',
	ensure  => absent,
	require => Package['nginx'],
}

file { 'vagrant-nginx-enable':
	path    => '/etc/nginx/sites-enabled/vagrant',
	target  => '/etc/nginx/sites-available/vagrant',
	ensure  => link,
	notify  => Service['nginx'],
	require => [
		File['vagrant-nginx'],
		File['default-nginx-disable'],
	],
}
