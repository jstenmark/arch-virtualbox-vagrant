#!/bin/bash
set -e
source build/build.sh

VAR_FILE="build/variables.json"
REPO=$(grep '"repo":' "$VAR_FILE" | awk -v FS="(\")" '{print $4}')

[[ -z "$REPO" ]] && fail "repo is not set in $VAR_FILE example: https://ftp.lysator.liu.se/pub/archlinux"

MIRROR="${REPO}/\$repo/os/\$arch"
SHA1SUMS=$(curl -s "${REPO}/iso/latest/sha1sums.txt")
ISO_NAME=$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $2 }')
ISO_URL="${REPO}/iso/latest/${ISO_NAME}"
ISO_CHECKSUM=$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $1 }')

set_var iso_name="$ISO_NAME"
set_var mirror="$MIRROR"
set_var iso_url="$ISO_URL"
set_var iso_checksum="$ISO_CHECKSUM"
set_var iso_checksum_type="SHA1"

packer build \
  -var-file "$VAR_FILE" \
  --force \
  build/template.json
vagrant box add "$ISO_NAME" "$ISO_NAME.box" --force
notify_msg
