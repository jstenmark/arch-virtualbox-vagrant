#!/bin/bash
export DEBUGGING="false"
export REPO_EXAMPLE="https://ftp.lysator.liu.se/pub/archlinux"

CONFIG_PACKER="packer.json"
CONFIG_VBOX="virtualbox.json"

REPO="$(grep '"repo":' "$CONFIG_VBOX" | awk -v FS="(\")" '{print $4}')"
SHA1SUMS=$(curl -s "${REPO}/iso/latest/sha1sums.txt")

ISO_NAME=$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $2 }')

[[ -f "$CONFIG_PACKER" ]] || fail "Missing Packer config"
[[ -f "$CONFIG_VBOX" ]] || fail "Could not create VBOX config"
[[ -z "$REPO" ]] && fail "Missing 'repo' in VBOX config ($REPO_EXAMPLE)"

export ISO_NAME
