#!/bin/bash
set -e
source build/build.sh

# load arch repo
VAR_FILE="build/variables.json"
REPO=$(grep '"repo":' "$VAR_FILE" | awk -v FS="(\")" '{print $4}')
[[ -z "$REPO" ]] && fail "repo is not set in $VAR_FILE example: https://ftp.lysator.liu.se/pub/archlinux"

# arch repo urls
SHA1SUMS=$(curl -s "${REPO}/iso/latest/sha1sums.txt")
ISO_NAME=$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $2 }')

# write repo urls to varfile
set_var iso_name="$ISO_NAME"
set_var mirror="${REPO}/\$repo/os/\$arch"
set_var iso_url="${REPO}/iso/latest/${ISO_NAME}"
set_var iso_checksum=$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $1 }')

# build image
packer build \
  -var-file "$VAR_FILE" \
  --force \
  build/template.json

# add image to vagrant
vagrant box add "$ISO_NAME" "$ISO_NAME.box" --force

# success output
notify-send Packer "Build completed in $(get_execution_time)"
echo "Build completed in $(get_execution_time)"
echo "Init image with:"
echo ""
echo "mkdir ../archbox && cd ../archbox"
echo "vagrant init" "$ISO_NAME"
echo "vagrant up"
echo "vagrant ssh"