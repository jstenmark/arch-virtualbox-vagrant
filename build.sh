#!/bin/bash
VAR_FILE="variables.json"
PACKER_FILE="packer.json"
REPO="https://ftp.lysator.liu.se/pub/archlinux"

set -e
source scripts/functions/build_functions.sh

update_var_file
packer build --force -var-file $VAR_FILE $PACKER_FILE
vagrant box add $ISO_NAME $ISO_NAME.box --force
notify_msg
