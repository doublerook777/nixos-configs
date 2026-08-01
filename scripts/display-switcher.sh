#!/bin/bash

THEME="$HOME/.config/rofi/context-menu.rasi"

outputs_json=$(niri msg -j outputs)
names=$(jq -r 'keys[]' <<<"$outputs_json")
internal=$(grep -m1 'eDP' <<<"$names")
externals=$(grep -v 'eDP' <<<"$names")
ext_count=$(grep -c . <<<"$externals" 2>/dev/null || echo 0)

if [ -z "$externals" ]; then
  notify-send "Display Switcher" "No external display connected"
  exit 0
fi

if [ "$ext_count" -gt 1 ]; then
  external=$(rofi -dmenu -theme "$THEME" <<<"$externals")
  [ -z "$external" ] && exit 0
else
  external="$externals"
fi

mode=$(printf "Extend (side by side)\nMirror\nLaptop Screen Only\nExternal Only" | rofi -dmenu -theme "$THEME")
[ -z "$mode" ] && exit 0

case "$mode" in
"Extend (side by side)")
  niri msg output "$internal" on
  niri msg output "$external" on
  internal_width=$(jq -r --arg n "$internal" '.[$n].logical.width // .[$n].modes[.[$n].current_mode].width' <<<"$outputs_json")
  niri msg output "$internal" position 0 0
  niri msg output "$external" position "$internal_width" 0
  ;;
"Mirror")
  niri msg output "$internal" on
  niri msg output "$external" on
  niri msg output "$internal" position 0 0
  niri msg output "$external" position 0 0
  ;;
"Laptop Screen Only")
  niri msg output "$internal" on
  niri msg output "$external" off
  ;;
"External Only")
  niri msg output "$external" on
  niri msg output "$internal" off
  ;;
esac

notify-send "Display Switcher" "$mode"
