#!/bin/bash
source build/functions.sh
source build/env.sh

case $1 in
  build)
    source build/build.sh
    ;;
  dev)
    DEBUGGING="true"
    source build/build.sh
    ;;
  test)
    find . -iname "*.sh" -exec shellcheck --exclude=SC1091 {} + &&
      find . -iname "*.sh" -exec ./shfmt -i 2 -ci -d {} + &&
      packer validate -var-file "$CONFIG_VBOX" "$CONFIG_PACKER"
    ;;
  shfmt-write)
    find . -iname "*.sh" -exec ./shfmt -i 2 -ci -d -w {} +
    ;;
  *)
    msg red "[ERROR]" "Missing args"
    msg yellow "" "build | shfmt-write | test"
    exit 1
    ;;
esac
