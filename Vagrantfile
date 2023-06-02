# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = 'kvm'
  end

  config.vm.define "zabbix-server" do |zabbix_server|
    config.vm.box = "generic/ubuntu2204"
    config.vm.hostname = "zabbix.server"
    config.vm.network "public_network", bridge: "virbr0", dev: "virbr0", ip: "192.168.122.1"
  end

  config.vm.provision:shell, inline: <<-SHELL
    echo "root:rootroot" | sudo chpasswd
  SHELL

  config.vm.provision:shell, path: "bootstrap.sh"
end



