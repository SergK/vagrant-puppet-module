#!/bin/bash -x

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y
sudo apt-get install -y git puppet puppet-lint

sudo chown vagrant.vagrant -R /home/vagrant/

