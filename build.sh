#!/bin/bash
source build/functions.sh
source build/env.sh

set_var iso_name="$ISO_NAME"
set_var mirror="${REPO}/\$repo/os/\$arch"
set_var iso_url="${REPO}/iso/latest/${ISO_NAME}"
set_var iso_checksum="$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $1 }')"

msg cyan "[PACKER]" "Starting build"
no_debug && packer build --force \
  -var-file "$CONFIG_VBOX" \
  "$CONFIG_PACKER"

msg cyan "[PACKER]" "$(build_ok_msg)"
no_debug && notify-send Packer "$(build_ok_msg)"

msg cyan "[VAGRANT]" "Adding image to vagrant"
no_debug && vagrant box add --force "$ISO_NAME" "$ISO_NAME.box"

msg cyan "[VAGRANT]" "Init box instructions:"
msg yellow "cd .. && mkdir archbox && cd archbox"
msg yellow "vagrant init $ISO_NAME"
msg yellow "vagrant up && vagrant ssh"
