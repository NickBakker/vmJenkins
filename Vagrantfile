# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

   config.vm.define :jenkins do |jenkins|
      jenkins.vm.box = "roboxes/centos8"  
	  jenkins.vm.network "private_network", type: "dhcp"
	  jenkins.vm.provider "virtualbox" do |vb|
	     vb.memory = 2048
	     vb.name = "jenkins"
      end	  
      jenkins.vm.provision "shell" do |s|
          s.path = "bootjenkins.sh"
      end
   end
   
end
