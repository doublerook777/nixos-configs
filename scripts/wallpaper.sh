#!/bin/bash

export WAYLAND_DISPLAY=wayland-1
export XDG_RUNTIME_DIR=/run/user/1000

WALLPAPER_DIR="/home/caelum/nixos-configs/wallpapers"

until swww query &>/dev/null; do
  sleep 1
done

while true; do
  img=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
  swww img "$img" --transition-type wave --transition-duration 2 --transition-fps 60
  sleep 300
done
