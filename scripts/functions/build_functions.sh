#!/bin/bash

# set json env var
function set_var() {
    KEY=$(echo $1 | cut -f1 -d=)
    VALUE=$(echo $1 | format_value $(cut -f2 -d=))
    sed -i '/'$KEY'"/c\  \"'$KEY'\": '$VALUE',' $VAR_FILE
}

# format value to json
function format_value() {
    shopt -s nocasematch
    if [[ $1 =~ ^(true|false)$ ]] ; then
        VALUE=${1,,}
    elif ! [[ $1 =~ ^[0-9]+$ ]] ; then
        VALUE=\"$1\"
    else
        VALUE=$1
    fi
    shopt -u nocasematch
    echo $VALUE
}

function update_var_file() {
    MIRROR="${REPO}/\$repo/os/\$arch"
    SHA1SUMS=$(curl -s "${REPO}/iso/latest/sha1sums.txt")
    ISO_NAME=$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $2 }')
    ISO_URL="${REPO}/iso/latest/${ISO_NAME}"
    ISO_CHECKSUM=$(echo "$SHA1SUMS" | awk '/x86_64.iso/{ print $1 }')

    set_var iso_name=$ISO_NAME
    set_var mirror=$MIRROR
    set_var iso_url=$ISO_URL
    set_var iso_checksum=$ISO_CHECKSUM
    set_var iso_checksum_type="SHA1"
}

SECONDS=0
function notify_msg() {
    EXECUTION_TIME="$((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
    MSG="Build completed in ${EXECUTION_TIME}"
    echo $MSG
    notify-send Packer $MSG
}
