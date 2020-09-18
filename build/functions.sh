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

  echo -e "${COLOR}${2}\e[0m"
}

# set json env var
function set_var() {
  KEY=$(echo "$1" | cut -f1 -d=)
  VALUE=$(echo "$1" | format_value "$(cut -f2 -d=)")
  sed -i '/'"$KEY"'"/c\  \"'"$KEY"'\": '"$VALUE"',' "$CONFIG_VBOX"
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
  printf '%s\n' "$1" >&2 # Send message to stderr.
  exit "${2-1}"          # Return a code specified by $2 or 1 by default.
}

SECONDS=0
function build_ok_msg() {
  # shellcheck disable=SC2004
  echo "[Build] finished in $(((${SECONDS} / 60) % 60))min $(($SECONDS % 60))sec"
}

function save_vbox_config() {
  echo "$1" >"$CONFIG_VBOX"
  msg green "Created VBOX config: $CONFIG_VBOX"
}
