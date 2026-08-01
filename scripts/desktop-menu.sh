#!/bin/bash

THEME="$HOME/.config/rofi/context-menu.rasi"
SCRIPTS="/home/caelum/nixos-configs/scripts"

chosen=$(printf "Terminal\nFile Manager\nLock\nDisplay Switcher\nAudio Switcher" | rofi -dmenu -theme "$THEME")

case "$chosen" in
"Terminal") kitty ;;
"File Manager") kitty yazi ;;
"Lock") qylock-lock ;;
"Display Switcher") bash "$SCRIPTS/display-switcher.sh" ;;
"Audio Switcher") bash "$SCRIPTS/audio-switcher.sh" ;;
esac
