VNMP - Vagrant Nginx MySQL PHP
================================
*A supersimple way to have a fully fladged webserver on your machine*

Prerequisites
-------------

* [VirtualBox](http://www.virtualbox.org)
* [Vagrant](http://www.vagrantup.com). The [vagrant-vbguest plugin](http://blog.carlossanchez.eu/2012/05/03/automatically-download-and-install-virtualbox-guest-additions-in-vagrant/) is also nice to have

Usage
-----

1. Clone this repo into some directory and cd into it
2. Edit the Vagrantfile. The only thing that might need changing is the shared source folder. Have it point to some folder on your host machine that contains an index.php file.
3. vagrant up
4. Visit [http://localhost:8080](http://localhost:8080) to access your home folder
5. Visit [http://localhost:8080/phpmyadmin](http://localhost:8080/phpmyadmin) for phpmyadmin
6. SSH to localhost:2222 (or just do "vagrant ssh" if you have a decent host machine like Linux)

MySQL Configuration
-------------------

The MySQL server is accessible from your PHP code using both the unix
file socket at */var/run/mysqld/mysqld.sock* or using the port *3306*

The default login details for the MySQL root user are:

Username: *vagrant*
Password: *vagrant*

Hints
-----

* Use "vagrant provision" to re-provision the VM anytime you make a change to the Puppet manifest or module files. Do not change anything manually in the VM!
