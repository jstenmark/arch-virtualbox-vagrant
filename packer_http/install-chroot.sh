#!/bin/bash
post() {
  install --directory --owner="$1" --group="$1" --mode=0700 /home/"$1"/.ssh
  curl --output /home/"$1"/.ssh/authorized_keys --location https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub
  chown "$1":"$1" /home/"$1"/.ssh/authorized_keys
  chmod 0600 /home/"$1"/.ssh/authorized_keys
}
