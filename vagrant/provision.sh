#!/bin/sh
# this script must be executed as root user

#pacman --noconfirm -Syu
# remove guest utils provided by the box (they do not work in the GUI environment)
# pacman --noconfirm -R virtualbox-guest-utils-nox
# feel free to add/remove packages as you need
#pacman --noconfirm -S \
#    base-devel net-tools vim wget git unzip openssh bash-completion \
#    dialog \
#    xorg-server xorg-xfontsel xorg-xrdb xorg-setxkbmap xorg-xinit xf86-video-intel xf86-input-synaptics xf86-input-libinput \
#    i3 dmenu \
#    ttf-inconsolata terminus-font \
#    termite chromium \
#    php php-mcrypt php-xsl xdebug php-intl php-gd composer \
#    virtualbox-guest-utils

#VBoxManage setextradata global GUI/Customizations noMenuBar,noStatusBar
