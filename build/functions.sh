#!/bin/bash
function msg() {
  case $1 in
    red)
      COLOR='\e[31m'
      ;;
    green)
      COLOR='\e[32m'
      ;;
    yellow)
      COLOR='\e[33m'
      ;;
    blue)
      COLOR='\e[34m'
      ;;
    cyan)
      COLOR='\e[36m'
      ;;
    *)
      COLOR='\e[34m'
      ;;
  esac

  [[ -z "$2" ]] &&
    echo -e "${COLOR}${*:2}\e[0m" ||
    echo -e "${COLOR}${2}\e[0m ${*:3}"
}

function okk() {
  # shellcheck disable=SC2015
  [[ $PRECOMMIT == "true" ]] &&
    msg green "[PRE-COMMIT-HOOK]" "$1" ||
    msg green "" "$1"
}

function err() {
  # shellcheck disable=SC2015
  [[ $PRECOMMIT == "true" ]] &&
    msg red "[PRE-COMMIT-HOOK]" "$1" ||
    msg red "[ERROR]" "$1"
  exit 1
}

# check if debuging and return err
function no_debug() {
  [[ "$DEBUGGING" == "true" ]] && return 1 || return 0
}

# set json env var
function set_var() {
  KEY=$(echo "$1" | cut -f1 -d=)
  VALUE=$(echo "$1" | format_value "$(cut -f2 -d=)")
  sed -i '/'"$KEY"'"/c\  \"'"$KEY"'\": '"$VALUE"',' "$CONFIG_VBOX"
  msg cyan "[VIRTUALBOX]" "$KEY=$VALUE"
}

# format value to json
function format_value() {
  shopt -s nocasematch
  if [[ $1 =~ ^(true|false)$ ]]; then
    VALUE=${1,,} # lowercase bool
  elif ! [[ $1 =~ ^[0-9]+$ ]]; then
    VALUE=\"$1\" # str
  else
    VALUE=$1 #int
  fi
  shopt -u nocasematch
  echo "$VALUE"
}

function fail() {
  msg red "[ERROR]" "$1"
  exit "${2-1}" # Return a code specified by $2 or 1 by default.
}

SECONDS=0
function build_ok_msg() {
  # shellcheck disable=SC2004
  echo "Build finished in $(((${SECONDS} / 60) % 60))min $(($SECONDS % 60))sec"
}
