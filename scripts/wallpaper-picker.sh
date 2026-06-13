#!/bin/bash

WALLPAPER_DIR="/home/caelum/nixos-configs/wallpapers"

chosen=$(find "$WALLPAPER_DIR" -type f | sed 's|.*/||' | fuzzel --dmenu --prompt "Wallpaper: ")

[ -z "$chosen" ] && exit 0

swww img "$WALLPAPER_DIR/$chosen" \
  --transition-type wave \
  --transition-duration 2 \
  --transition-fps 60
