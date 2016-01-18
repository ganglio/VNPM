unless Vagrant.has_plugin?("vagrant-vbguest")
	raise 'vagrant-vbguest is not installed: vagrant plugin install vagrant-vbguest'
end

Vagrant.configure("2") do |config|

	config.vm.define "VNPM" do |machine|

		machine.vm.box = "ubuntu/trusty64"

		config.vm.hostname = "VNPM"
		machine.vm.network "private_network", type: "dhcp"

		# mysql
		machine.vm.network "forwarded_port", guest:3306, host:3306

		# nginx
		machine.vm.network "forwarded_port", guest:80, host:8080
		machine.vm.network "forwarded_port", guest:443, host:8443

		# apache
		machine.vm.network "forwarded_port", guest:81, host:8081
		machine.vm.network "forwarded_port", guest:444, host:8444

		# xdebug
		machine.vm.network "forwarded_port", guest: 9000, host: 9000

		# Shared DocRoot
		machine.vm.synced_folder "./htdocs", "/var/www"
		machine.vm.synced_folder "..", "/home/vagrant/Devel"

		# Some VM configuration
		machine.vm.provider "virtualbox" do |v|
			v.memory = 2048
			v.cpus = 2
		end

		# Enable provisioning with Puppet stand alone.

		machine.vm.provision :puppet, :module_path => "puppet/modules" do |puppet|
			puppet.manifests_path = "puppet/manifests"
			puppet.manifest_file  = "base.pp"
		end
	end

end
