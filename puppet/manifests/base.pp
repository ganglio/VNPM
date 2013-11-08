group { 'puppet':
	ensure => present,
}

exec { '10gen apt-key':
	command => '/usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10',
}

file { '10gen.list':
	path    => '/etc/apt/sources.list.d/10gen.list',
	ensure  => file,
	replace => true,
	source  => 'puppet:///modules/apt/10gen.list',
	require => Exec['10gen apt-key'],
}

exec { 'apt-get update':
	command => '/usr/bin/apt-get update',
	require => File['10gen.list']
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

package { 'php5-dev':
	ensure  => present,
	require => Exec['apt-get update'],
}

package { 'php-pear':
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

package { 'mongodb-10gen':
	ensure  => present,
	require => Exec['apt-get update'],
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

package { 'make':
	ensure => present,
	require => Exec['apt-get update'],
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

exec { 'Install php-mongo extension':
	command => '/usr/bin/pecl install mongo',
	unless => '/usr/bin/pecl list mongo',
	notify  => Service['php5-fpm'],
	require => [
		Package["php5-dev"],
		Package["php-pear"],
    Package["make"],
	],
}

file { 'php5-fpm mongo conf':
	path    => '/etc/php5/conf.d/mongo.ini',
	ensure  => file,
	replace => true,
	notify  => Service['php5-fpm'],
	require => [
		Package['php5-fpm'],
		Exec['Install php-mongo extension'],
	],
	source => 'puppet:///modules/php5-mongo/mongo.ini',
}
