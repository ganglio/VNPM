group { 'puppet':
	ensure => present,
}

import "lib"
include "nginx"
include "php-fpm"
include "mysql"
include "phpmyadmin"