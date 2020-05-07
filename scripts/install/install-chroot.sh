#!/bin/bash
function colormsg() {
  Green='\e[0;32m'
  Reset='\e[0m'
  echo -e "${Green}$1${Reset}"
}
post() {
  colormsg "==> POSTINSTALL CREATE USER DIR"
  install --directory --owner=vagrant --group=vagrant --mode=0700 /home/vagrant/.ssh
  curl --output /home/vagrant/.ssh/authorized_keys --location https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub
  chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
  chmod 0600 /home/vagrant/.ssh/authorized_keys
}
