#!/bin/bash

THEME="$HOME/.config/rofi/context-menu.rasi"
WIDE_THEME="window { width: 420px; }"

wifi_data=$(nmcli -t -f active,ssid,security,signal dev wifi list)
current_ssid=$(awk -F: '$1=="yes"{print $2}' <<<"$wifi_data")

ask_autoconnect() {
  local ssid="$1"
  local choice
  choice=$(printf "Yes\nNo" | rofi -dmenu -theme "$THEME" -p "Connect automatically to $ssid?")
  if [ "$choice" = "No" ]; then
    nmcli connection modify "$ssid" connection.autoconnect no
  fi
}

list_networks() {
  awk -F: '
    $2 != "" && !seen[$2]++ {
      marker = ($1 == "yes") ? "󰸞" : ($3 == "" ? "󰤨" : "󰤪")
      printf "%s %s (%s%%)\n", marker, $2, $4
    }' <<<"$wifi_data" | sort -t'(' -k2 -rn
}

connect_to() {
  local chosen="$1"
  local ssid
  ssid=$(sed -E 's/^. //; s/ \([0-9]+%\)$//' <<<"$chosen")

  if [ "$ssid" = "$current_ssid" ]; then
    notify-send "Wi-Fi" "Already connected to $ssid"
    return
  fi

  if nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then
    if nmcli connection up "$ssid" &>/dev/null; then
      notify-send "Wi-Fi" "Connected to $ssid"
    else
      notify-send "Wi-Fi" "Failed to connect to $ssid" -u critical
    fi
    return
  fi

  local security
  security=$(awk -F: -v s="$ssid" '$2==s{print $3; exit}' <<<"$wifi_data")

  if [ -z "$security" ]; then
    if nmcli dev wifi connect "$ssid" &>/dev/null; then
      notify-send "Wi-Fi" "Connected to $ssid"
      ask_autoconnect "$ssid"
    else
      notify-send "Wi-Fi" "Failed to connect to $ssid" -u critical
    fi
    return
  fi

  local password
  password=$(rofi -dmenu -password -theme "$THEME" -theme-str 'entry { enabled: true; }' -p "Password for $ssid")
  [ -z "$password" ] && return

  if nmcli dev wifi connect "$ssid" password "$password" &>/dev/null; then
    notify-send "Wi-Fi" "Connected to $ssid"
    ask_autoconnect "$ssid"
  else
    notify-send "Wi-Fi" "Failed to connect — check password" -u critical
  fi
}

show_all_menu() {
  local full_chosen
  full_chosen=$(list_networks | rofi -dmenu -theme "$THEME" -theme-str "$WIDE_THEME" -p "All Networks")

  if [ -z "$full_chosen" ]; then
    main_menu
    return
  fi

  connect_to "$full_chosen"
}

build_menu() {
  local wifi_status
  wifi_status=$(nmcli radio wifi)

  if [ "$wifi_status" = "enabled" ]; then
    echo "󰖪 Turn Wi-Fi Off"
  else
    echo "󰖩 Turn Wi-Fi On"
  fi
  echo "󰑐 Rescan"

  if [ "$wifi_status" = "enabled" ]; then
    echo "󰍉 Show All Networks"
    list_networks
  fi
}

main_menu() {
  local chosen
  chosen=$(build_menu | rofi -dmenu -theme "$THEME" -p "Network")
  [ -z "$chosen" ] && exit 0

  case "$chosen" in
  *"Turn Wi-Fi Off")
    nmcli radio wifi off
    notify-send "Wi-Fi" "Turned off"
    exit 0
    ;;
  *"Turn Wi-Fi On")
    nmcli radio wifi on
    notify-send "Wi-Fi" "Turned on"
    exit 0
    ;;
  *"Rescan")
    nmcli dev wifi rescan &>/dev/null
    sleep 2
    wifi_data=$(nmcli -t -f active,ssid,security,signal dev wifi list)
    show_all_menu
    exit 0
    ;;
  *"Show All Networks")
    show_all_menu
    exit 0
    ;;
  esac

  connect_to "$chosen"
}

main_menu
