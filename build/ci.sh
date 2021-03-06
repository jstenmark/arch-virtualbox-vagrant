#!/bin/bash
set -x
pwd
source build/functions.sh
source build/env.sh

case $1 in

  install-packer)
    PACKER_CURRENT_VERSION="$(curl -s https://checkpoint-api.hashicorp.com/v1/check/packer | jq -r -M '.current_version')"
    PACKER_URL="https://releases.hashicorp.com/packer/$PACKER_CURRENT_VERSION/packer_${PACKER_CURRENT_VERSION}_linux_amd64.zip"
    PACKER_SHA256="https://releases.hashicorp.com/packer/$PACKER_CURRENT_VERSION/packer_${PACKER_CURRENT_VERSION}_SHA256SUMS"
    PACKER_SHA256_SIG="https://releases.hashicorp.com/packer/$PACKER_CURRENT_VERSION/packer_${PACKER_CURRENT_VERSION}_SHA256SUMS.sig"
    HASHICORP_FINGERPRINT=91a6e7f85d05c65630bef18951852d87348ffc4c
    HASHICORP_KEY="https://keybase.io/hashicorp/pgp_keys.asc?fingerprint=${HASHICORP_FINGERPRINT}"
    curl -LO "${PACKER_URL}"
    curl -LO "${PACKER_SHA256}"
    curl -LO "${PACKER_SHA256_SIG}"
    wget -Lo hashicorp.key "${HASHICORP_KEY}"
    gpg --with-fingerprint --with-colons hashicorp.key | grep ${HASHICORP_FINGERPRINT^^}
    gpg --import hashicorp.key
    gpg --verify "packer_${PACKER_CURRENT_VERSION}_SHA256SUMS.sig" "packer_${PACKER_CURRENT_VERSION}_SHA256SUMS"
    grep linux_amd64 "packer_${PACKER_CURRENT_VERSION}_SHA256SUMS" >packer_SHA256SUM_linux_amd64
    sha256sum --check --status packer_SHA256SUM_linux_amd64
    unzip "packer_${PACKER_CURRENT_VERSION}_linux_amd64.zip"
    ./packer --version
    ;;

  install-shfmt)
    SHFMT_VERSION="$(curl -s https://api.github.com/repos/mvdan/sh/releases/latest | jq -r -M '.tag_name')"
    curl -Lo shfmt https://github.com/mvdan/sh/releases/download/"${SHFMT_VERSION}"/shfmt_"${SHFMT_VERSION}"_linux_amd64
    chmod +x ./shfmt
    ./shfmt --version
    ;;

  verify-ci)
    ./packer validate -var-file "$CONFIG_VBOX" "$CONFIG_PACKER"
    ;;

  # We use + instead of \; here because find doesn't pass
  # the exit code through when used with \;
  shellcheck)
    find . -iname "*.sh" -exec shellcheck --exclude=SC1091 {} +
    ;;

  shfmt)
    find . -iname "*.sh" -exec ./shfmt -i 2 -ci -d {} +
    ;;

  *)
    exit 1
    ;;
esac
