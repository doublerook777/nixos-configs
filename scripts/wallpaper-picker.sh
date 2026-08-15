#!/bin/bash

WALLPAPER_DIR="/home/caelum/nixos-configs/wallpapers"
THEME="$HOME/.config/rofi/wallpaper-picker.rasi"

list_entries() {
  find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) |
    sort |
    while IFS= read -r img; do
      printf '%s\0icon\x1f%s\n' "$(basename "$img")" "$img"
    done
}

chosen=$(list_entries | rofi -dmenu -show-icons -theme "$THEME")
[ -z "$chosen" ] && exit 0

awww img "$WALLPAPER_DIR/$chosen" \
  --transition-type wave \
  --transition-duration 2 \
  --transition-fps 60
