class mysql {
	package { 'mysql-server':
		ensure  => present,
		require => Exec['apt-get update'],
	}

	exec { "create-db-user":
		unless  => "/usr/bin/mysqladmin -uvagrant -pvagrant status",
		command => "/usr/bin/mysql -uroot -p -e \"create user vagrant@'localhost' identified by 'vagrant'; grant all on *.* to vagrant@'localhost'; flush privileges;\"",
		require => Service["mysql"],
	}

	service { 'mysql':
		ensure  => running,
		require => Package['mysql-server'],
	}
}