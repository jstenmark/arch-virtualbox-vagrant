#!/bin/bash
set -e
source build/functions.sh
source build/env.sh

msg cyan "[Build] Write config vars"
set_var iso_name="$ISO_NAME"
set_var mirror="${REPO}/\$repo/os/\$arch"
set_var iso_url="${REPO}/iso/latest/${ISO_NAME}"
set_var iso_checksum="$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $1 }')"

msg cyan "[Build] Init $ISO_NAME"
packer build --force \
  -var-file "$CONFIG_VBOX" \
  "$CONFIG_PACKER"

msg cyan "[Build] Add image to vagrant"
vagrant box add "$ISO_NAME" "$ISO_NAME.box" --force

msg green "$(build_ok_msg)" && notify-send Packer "$(build_ok_msg)"
msg cyan "\\n\\n  Vagrant instructions:"
msg yellow "
cd .. && mkdir archbox && cd archbox
vagrant init $ISO_NAME
vagrant up && vagrant ssh
"
