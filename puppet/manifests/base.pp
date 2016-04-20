group { 'puppet':
	ensure => present,
}

import "lib"
include "nginx"
include "apache2"
include "php-fpm"
include "mysql"
include "phpmyadmin"
include "dotfiles"