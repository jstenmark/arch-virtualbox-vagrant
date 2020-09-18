#!/bin/bash
set -e
function msg() {
  case $1 in
    red)
      COLOR='\e[31m'
      ;;
    green)
      COLOR='\e[32m'
      ;;
    yellow)
      COLOR='\e[33m'
      ;;
    blue)
      COLOR='\e[34m'
      ;;
    cyan)
      COLOR='\e[36m'
      ;;
    *)
      COLOR='\e[34m'
      ;;
  esac

  echo -e "${COLOR}${2}\e[0m"
}

# get disk
if [ -e /dev/vda ]; then
  DISK=/dev/vda
elif [ -e /dev/sda ]; then
  DISK=/dev/sda
else
  msg red "ERROR: There is no disk available for installation" >&2
  exit 1
fi
SWAP_PARTITION="${DISK}1"
ROOT_PARTITION="${DISK}2"

msg yellow "==> clearing partition table on $DISK"
memory_size_in_kilobytes=$(free | awk '/^Mem:/ { print $2 }')
swap_size_in_kilobytes=$((memory_size_in_kilobytes * 2))
sfdisk "$DISK" <<EOF
label: dos
size=${swap_size_in_kilobytes}KiB, type=82
                                   type=83, bootable
EOF

msg yellow "==> creating swap partition on $SWAP_PARTITION"
TARGET_DIR='/mnt'
mkswap "$SWAP_PARTITION" && msg green "SWAP OK"

msg yellow "==> creating /root filesystem (ext4)"
mkfs.ext4 -L "rootfs" "$ROOT_PARTITION" && msg green "FILESYSTEM OK"

msg yellow "==> mounting $ROOT_PARTITION to $TARGET_DIR"
mount "$ROOT_PARTITION" "$TARGET_DIR" && msg green "MOUNT OK"

msg yellow "==> bootstrapping the base installation"
pacman -Sy --noconfirm reflector >>/dev/null
reflector -c Sweden --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
pacstrap -M "$TARGET_DIR" \
  base linux grub openssh sudo polkit \
  haveged netctl python reflector \
  >>/dev/null
arch-chroot "$TARGET_DIR" \
  /usr/bin/sed -i 's/^#Server/Server/' \
  /etc/pacman.d/mirrorlist
msg green "BOOTSTRAP OK"

msg yellow "==> generating the filesystem table"
swapon "$SWAP_PARTITION"
genfstab -p "$TARGET_DIR" >>"${TARGET_DIR}/etc/fstab"
swapoff "$SWAP_PARTITION"
msg green "FSTAB OK"

msg yellow "==> entering chroot and configuring system"
DISK="$DISK" arch-chroot "$TARGET_DIR" /bin/bash
msg green "CHROOT OK"
