#!/bin/bash
source build/functions.sh
source build/env.sh

PRECOMMIT=$([[ "$2" == "precommit" ]] && echo "true")

case $1 in
  build)
    source build/build.sh
    ;;
  dev)
    DEBUGGING="true"
    source build/build.sh
    ;;
  test)
    # shellcheck disable=SC2015
    find . -iname "*.sh" -exec shellcheck --exclude=SC1091 {} + &&
      okk "shellcheck ok" || err "shellcheck failed"

    # shellcheck disable=SC2015
    find . -iname "*.sh" -exec ./shfmt -i 2 -ci -d {} + &&
      okk "shfmt ok" || err "shfmt failed"

    # shellcheck disable=SC2015
    packer validate -var-file "$CONFIG_VBOX" "$CONFIG_PACKER" &&
      okk "packer ok" || err "packer failed"
    ;;
  fix)
    find . -iname "*.sh" -exec ./shfmt -i 2 -ci -d -w {} +
    ;;
  *)
    msg red "[ERROR]" "Missing args"
    msg yellow "" "build | dev | test | fix"
    exit 1
    ;;
esac
