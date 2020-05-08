#!/bin/bash

# set json env var
function set_var() {
  KEY=$(echo "$1" | cut -f1 -d=)
  VALUE=$(echo "$1" | format_value "$(cut -f2 -d=)")
  sed -i '/'"$KEY"'"/c\  \"'"$KEY"'\": '"$VALUE"',' "$VAR_FILE"
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

SECONDS=0
function notify_msg() {
  # shellcheck disable=SC2004
  EXECUTION_TIME="$(((${SECONDS} / 60) % 60))min $(($SECONDS % 60))sec"
  MSG="Build completed in ${EXECUTION_TIME}"
  echo "$MSG"
  notify-send Packer "$MSG"
}

function fail() {
  printf '%s\n' "$1" >&2 # Send message to stderr.
  exit "${2-1}"          # Return a code specified by $2 or 1 by default.
}
