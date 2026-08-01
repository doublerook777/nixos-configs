#!/bin/bash

THEME="$HOME/.config/rofi/context-menu.rasi"

declare -A id_map
menu=""

while IFS= read -r line; do
  id=$(grep -oP '\d+(?=\.)' <<<"$line")
  name=$(sed -E 's/.*[0-9]+\. //; s/ \[vol.*//' <<<"$line")
  [ -z "$id" ] && continue
  id_map["$name"]="$id"
  menu+="$name"$'\n'
done < <(wpctl status | awk '/Sinks:/{flag=1; next} /Sources:/{flag=0} flag && NF')

chosen=$(echo -n "$menu" | rofi -dmenu -theme "$THEME")
[ -z "$chosen" ] && exit 0

wpctl set-default "${id_map[$chosen]}"
notify-send "Audio Output" "Switched to $chosen"
