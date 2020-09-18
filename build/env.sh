#!/bin/bash
#source build/functions.sh

TEMPLATE_VBOX=$(
  cat <<EOF
{
  "repo": "https://ftp.lysator.liu.se/pub/archlinux",
  "mirror": "https://ftp.lysator.liu.se/pub/archlinux/\$repo/os/\$arch",
  "iso_name": "archlinux-2020.09.01-x86_64.iso",
  "iso_url": "https://ftp.lysator.liu.se/pub/archlinux/iso/latest/archlinux-2020.09.01-x86_64.iso",
  "iso_checksum": "95ebacd83098b190e8f30cc28d8c57af0d0088a0",
  "disk_size": "20480",
  "memory": "1024",
  "video_memory": "64",
  "cpus": "2",
  "headless": "true",
  "boot_wait": "5s"
}
EOF
)

CONFIG_PACKER="config/packer.json"
CONFIG_VBOX="config/virtualbox.json"

# Config validation
[[ -f "$CONFIG_PACKER" ]] || fail "Missing Packer config"
[[ -f "$CONFIG_VBOX" ]] || save_vbox_config "$TEMPLATE_VBOX" || fail "Could not create VBOX config"

# Repo url
REPO="$(grep '"repo":' "$CONFIG_VBOX" | awk -v FS="(\")" '{print $4}')"
SHA1SUMS=$(curl -s "${REPO}/iso/latest/sha1sums.txt")
ISO_NAME=$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $2 }')
[[ -z "$REPO" ]] && fail "repo is not set in $CONFIG_VBOX example: https://ftp.lysator.liu.se/pub/archlinux"

export CONFIG_VBOX ISO_NAME REPO SHA1SUMS USAGE
