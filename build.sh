#!/bin/bash
set -e
source build/build.sh

update_var_file
packer_build
vagrant_add_box
notify_msg
