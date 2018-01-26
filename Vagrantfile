# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
BOX_IMAGE = "bertvv/centos72"

  config.vm.define "server1" do |server1|
    server1.vm.box = BOX_IMAGE
    server1.vm.hostname = "server1"
    server1.vm.network :private_network, ip: "192.168.0.11"
    server1.vm.provision "shell", inline: <<-SHELL
      sed -i '$ a 192.168.0.12 server2' /etc/hosts
      yum install git -y
      git clone https://github.com/Woodforfood/devops-training.git
      cd devops-training
      git checkout task2
      cat hello.txt
    SHELL
  end
  
  config.vm.define "server2" do |server2|
    server2.vm.box = BOX_IMAGE
    server2.vm.hostname = "server2"
    server2.vm.network :private_network, ip: "192.168.0.12"
    server2.vm.provision "shell", inline: <<-SHELL
      sed -i '$ a 192.168.0.11 server1' /etc/hosts
    SHELL
  end

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
end
