class dotfiles {
	package { 'git':
		ensure => 'present',
		require => Exec['apt-get update'],
	}

	package { 'zsh':
		ensure => 'present',
		require => Exec['apt-get update'],
	}

	exec { 'install dotfiles':
		command => '/usr/bin/curl -l https://raw.githubusercontent.com/ganglio/dotfiles/master/install.sh | /bin/sh',
		user    => 'vagrant',
		group   => 'vagrant',
		cwd     => '/home/vagrant',

		require => Package['git'],
	}

	exec { 'switch to zsh':
		command => '/usr/bin/chsh -s /bin/zsh vagrant',
		user    => 'root',
		group   => 'root',

		require => [
			Exec['install dotfiles'],
			Package['zsh'],
		]
	}
}