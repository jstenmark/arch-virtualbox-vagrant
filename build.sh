#/bin/bash
set -e

MIRROR="https://ftp.lysator.liu.se/pub/archlinux"
PKG_MIRROR="${MIRROR}/\$repo/os/\$arch"
SHA1SUMS=$(curl -s "${MIRROR}/iso/latest/sha1sums.txt")

ISO_NAME=$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $2 }')
ISO_URL="${MIRROR}/iso/latest/${ISO_NAME}"
ISO_CHECKSUM=$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $1 }')
ISO_CHECKSUM_TYPE="SHA1"

packer build \
	-var "mirror=$PKG_MIRROR" \
	-var "iso_url=$ISO_URL" \
	-var "iso_checksum=$ISO_CHECKSUM" \
	-var "iso_checksum_type=$ISO_CHECKSUM_TYPE" \
	packer.json

vagrant box add arch build/packer_arch_virtualbox.box --force
notify-send PACKER BUILD_COMPLETE
