#!/bin/bash

SELECTION="$(printf "1 - Suspend\n2 - Log out\n3 - Reboot\n4 - Hard reboot\n5 - Shutdown" | fuzzel --dmenu -l 5 -p "Power Menu: ")"

case $SELECTION in
*"Suspend")
  systemctl suspend
  ;;
*"Log out")
  swaymsg exit
  ;;
*"Reboot")
  systemctl reboot
  ;;
*"Hard reboot")
  pkexec "echo b > /proc/sysrq-trigger"
  ;;
*"Shutdown")
  systemctl poweroff
  ;;
esac
