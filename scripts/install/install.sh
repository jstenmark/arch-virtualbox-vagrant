#!/bin/bash
#install.sh
set -e
function colormsg ()
{
	Green='\e[0;32m'
	Reset='\e[0m'
    echo -e "${Green}$1${Reset}"
}
function get_disk()
{
	if [ -e /dev/vda ]; then
	  export DISK=/dev/vda
	elif [ -e /dev/sda ]; then
	  export DISK=/dev/sda
	else
	  echo "ERROR: There is no disk available for installation" >&2
	  exit 1
	fi
}

get_disk

SWAP_PARTITION="${DISK}1"
ROOT_PARTITION="${DISK}2"
TARGET_DIR='/mnt'
memory_size_in_kilobytes=$(free | awk '/^Mem:/ { print $2 }')
swap_size_in_kilobytes=$((memory_size_in_kilobytes * 2))

colormsg "==> clearing partition table on ${DISK}"
sfdisk "${DISK}" <<EOF
label: dos
size=${swap_size_in_kilobytes}KiB, type=82
                                   type=83, bootable
EOF

colormsg "==> creating swap partition on ${SWAP_PARTITION}"
mkswap ${SWAP_PARTITION}

colormsg "==> creating /root filesystem (ext4)"
mkfs.ext4 -L "rootfs" ${ROOT_PARTITION}

colormsg "==> mounting ${ROOT_PARTITION} to ${TARGET_DIR}"
mount ${ROOT_PARTITION} ${TARGET_DIR}

colormsg "==> bootstrapping the base installation"
if [ -n "${MIRROR}" ]; then
  echo MIRROR=$MIRROR
  echo "Server = ${MIRROR}" >> /etc/pacman.d/mirrorlist
else
  pacman -Sy --noconfirm reflector >> /dev/null
  reflector --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
fi
pacstrap -M ${TARGET_DIR} base linux grub openssh sudo polkit haveged netctl python reflector >> /dev/null
arch-chroot ${TARGET_DIR} /usr/bin/sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist

colormsg "==> generating the filesystem table"
swapon ${SWAP_PARTITION}
genfstab -p ${TARGET_DIR} >> "${TARGET_DIR}/etc/fstab"
swapoff ${SWAP_PARTITION}

colormsg "==> entering chroot and configuring system"
DISK=$DISK arch-chroot ${TARGET_DIR} /bin/bash

