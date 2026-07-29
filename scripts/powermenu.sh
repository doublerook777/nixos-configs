#!/bin/bash

chosen=$(printf "Lock\nLogout\nReboot\nShutdown\nHibernate" | fuzzel --dmenu --prompt "Power: ")

case "$chosen" in
"Lock") qylock-lock ;;
"Logout") niri msg action quit ;;
"Reboot") systemctl reboot ;;
"Shutdown") systemctl poweroff ;;
"Hibernate") systemctl hibernate ;;
esac
