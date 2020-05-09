#!/bin/bash
set -e
set -x

hostnamectl set-hostname arch
localectl set-keymap sv-latin1
timedatectl set-ntp true
