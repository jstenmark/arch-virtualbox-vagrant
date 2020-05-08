#!/bin/bash

set -e
set -x

sudo pacman -S --noconfirm virtualbox-guest-utils-nox
sudo systemctl enable vboxservice

# VirtualBox Guest Additions
#sudo pacman -S --noconfirm linux-headers virtualbox-guest-utils virtualbox-guest-dkms nfs-utils
#sudo echo -e 'vboxguest\nvboxsf\nvboxvideo' > /etc/modules-load.d/virtualbox.conf
#guest_version=\$(pacman -Q virtualbox-guest-dkms | awk '{ print \$2 }' | cut -d'-' -f1)
#kernel_version="\$(pacman -Q linux | awk '{ print \$2 }')-ARCH"
#sudo dkms install "vboxguest/\${guest_version}" -k "\${kernel_version}/x86_64"
#sudo systemctl enable dkms
#sudo systemctl enable rpcbind
