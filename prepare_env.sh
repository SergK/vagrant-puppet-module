#!/bin/bash

# This script will prepare Vagrant config file and bootstrap one

[ -z $1 ] && { echo "Please, run: ./`basename $0` puppet_module_name [PORT]";exit 1; }
MODULE_NAME=$1

tee ./Vagrantfile <<EOF
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu-14.04"

  config.vm.provider "virtualbox" do |v|
  v.customize ["modifyvm", :id, "--name", "puppet-module-${MODULE_NAME}"]
  v.customize ["modifyvm", :id, "--memory", "2048"]
  v.customize ["modifyvm", :id, "--cpus", "1"]
  v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provision :shell, path: "./bootstrap.sh"
  #PORT config.vm.network "forwarded_port", guest: 7777, host: 7777

  config.vm.synced_folder "./${MODULE_NAME}", "/etc/puppet/modules/${MODULE_NAME}", owner: "root", group: "root"

end

EOF

[ -z $2 ] || sed -i 's/#PORT.*/config.vm.network "forwarded_port", guest: '${2}', host: '${2}'/g' ./Vagrantfile

# creating directory for puppet
[ ! -d ${MODULE_NAME} ] && mkdir ./"${MODULE_NAME}"


echo "Please, put your module content in ${MODULE_NAME} directory"
echo "To start Vagrant, please run: vagrant up"
