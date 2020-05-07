#!/bin/bash
set -e
source .env
source scripts/functions/build_functions.sh

update_var_file
packer build --force -var-file "$VAR_FILE" "$PACKER_FILE"
vagrant box add "$ISO_NAME" "$ISO_NAME.box" --force
notify_msg
