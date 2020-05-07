#!/bin/bash
set -e
set -x

# setting hostname, locales, etc
hostnamectl set-hostname arch
localectl set-keymap sv-latin1
timedatectl set-ntp true



