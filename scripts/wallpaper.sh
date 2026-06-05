#!/bin/bash
sleep 2

WALLPAPER_DIR="/home/caelum/nixos-configs/wallpapers"

while true; do
  for img in "$WALLPAPER_DIR"/*; do
    swww img "$img" --transition-type wave --transition-duration 2
    sleep 300
  done
done
