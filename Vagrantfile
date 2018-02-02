# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
BOX_IMAGE = "bertvv/centos72"

  config.vm.define "apache" do |apache|
    apache.vm.box = BOX_IMAGE
    apache.vm.hostname = "apache"
    apache.vm.network :private_network, ip: "192.168.0.10"
    apache.vm.network :forwarded_port, guest: 80, host: 18080
    apache.vm.provision "shell", inline: <<-SHELL
      yum install httpd -y
      systemctl enable httpd
      systemctl start httpd
      systemctl stop firewalld
      echo LoadModule jk_module modules/mod_jk.so >> /etc/httpd/conf/httpd.conf
      echo JkWorkersFile conf/workers.properties >> /etc/httpd/conf/httpd.conf
      echo JkShmFile /tmp/shm >> /etc/httpd/conf/httpd.conf
      echo JkLogFile logs/mod_jk.log >> /etc/httpd/conf/httpd.conf
      echo JkLogLevel info >> /etc/httpd/conf/httpd.conf
      echo JkMount /test* lb >> /etc/httpd/conf/httpd.conf
      cp /vagrant/mod_jk.so /etc/httpd/modules
      touch workers.properties /etc/httpd/conf
      echo worker.list=lb >> /etc/httpd/conf/workers.properties
      echo worker.lb.type=lb >> /etc/httpd/conf/workers.properties
      echo worker.lb.balance_workers=tomcat1,tomcat2 >> /etc/httpd/conf/workers.properties
      echo worker.tomcat1.host=192.168.0.11 >> /etc/httpd/conf/workers.properties
      echo worker.tomcat1.port=8009 >> /etc/httpd/conf/workers.properties
      echo worker.tomcat1.type=ajp13 >> /etc/httpd/conf/workers.properties
      echo worker.tomcat2.host=192.168.0.12 >> /etc/httpd/conf/workers.properties
      echo worker.tomcat2.port=8009 >> /etc/httpd/conf/workers.properties
      echo worker.tomcat2.type=ajp13 >> /etc/httpd/conf/workers.properties
      systemctl restart httpd
    SHELL
  end

  config.vm.define "tomcat1" do |tomcat1|
    tomcat1.vm.box = BOX_IMAGE
    tomcat1.vm.hostname = "tomcat1"
    tomcat1.vm.network :private_network, ip: "192.168.0.11"
    tomcat1.vm.provision "shell", inline: <<-SHELL
      yum install install tomcat tomcat-webapps tomcat-admin-webapps -y
      systemctl enable tomcat
      systemctl start tomcat
      systemctl stop firewalld
      cd /usr/share/tomcat/webapps
      mkdir test
      echo Hello from tomcat111 >> /usr/share/tomcat/webapps/test/index.html
    SHELL
  end
  
  config.vm.define "tomcat2" do |tomcat2|
    tomcat2.vm.box = BOX_IMAGE
    tomcat2.vm.hostname = "tomcat2"
    tomcat2.vm.network :private_network, ip: "192.168.0.12"
    tomcat2.vm.provision "shell", inline: <<-SHELL
      yum install install tomcat tomcat-webapps tomcat-admin-webapps -y
      systemctl enable tomcat
      systemctl start tomcat
      systemctl stop firewalld
      cd /usr/share/tomcat/webapps
      mkdir test
      echo Hello from tomcat222 >> /usr/share/tomcat/webapps/test/index.html
    SHELL
  end

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.memory = 1024
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
end
