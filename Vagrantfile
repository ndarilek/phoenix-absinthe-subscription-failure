# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 4000, host: 4000

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y build-essential automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev libssh-dev inotify-tools libsodium-dev postgresql unzip git
    su postgres -c "psql -c \\"ALTER USER postgres PASSWORD 'postgres';\\""
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
    echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
    $HOME/.asdf/bin/asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang
    ERLANG_EXTRA_CONFIGURE_OPTIONS=--enable-dirty-schedulers $HOME/.asdf/bin/asdf install erlang 20.0
    $HOME/.asdf/bin/asdf global erlang 20.0
    $HOME/.asdf/bin/asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir
    $HOME/.asdf/bin/asdf install elixir 1.5.1
    $HOME/.asdf/bin/asdf global elixir 1.5.1
    $HOME/.asdf/bin/asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs
    $HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring
    $HOME/.asdf/bin/asdf install nodejs 8.4.0
    $HOME/.asdf/bin/asdf global nodejs 8.4.0
  SHELL

end
