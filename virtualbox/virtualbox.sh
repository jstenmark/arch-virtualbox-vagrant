#!/bin/bash
set -e
set -x

# Guest services
sudo pacman -S --noconfirm virtualbox-guest-utils xf86-video-vmware
sudo systemctl enable vboxservice

VBoxClient --clipboard
VBoxClient --draganddrop
VBoxClient --seamless
VBoxClient --checkhostversion
VBoxClient --vmsvga
