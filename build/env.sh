#!/bin/bash
CONFIG_PACKER="packer.json"
CONFIG_VBOX="virtualbox.json"

REPO="$(grep '"repo":' "$CONFIG_VBOX" | awk -v FS="(\")" '{print $4}')"
SHA1SUMS=$(curl -s "${REPO}/iso/latest/sha1sums.txt")
ISO_NAME=$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $2 }')

msg cyan "[INIT]" "Environment variables"
msg cyan "[INIT]" "$ISO_NAME"


[[ -f "$CONFIG_PACKER" ]] || fail "Missing Packer config"
[[ -f "$CONFIG_VBOX" ]] || fail "Could not create VBOX config"
[[ -z "$REPO" ]] && fail "$ERR_MISSING_REPO"
