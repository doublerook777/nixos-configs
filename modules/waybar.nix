{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;
        spacing = 6;

        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "tray"
          "mpris"
          "pulseaudio"
          "backlight"
          "network"
          "cpu"
          "memory"
          "battery"
          "custom/power"
        ];

        "tray" = {
            spacing = 8;
        };

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "●";
            default = "○";
          };
        };

        "niri/window" = {
          max-length = 50;
        };

        "clock" = {
          format = "{:%a %d %b  %I:%M %p}";
          format-alt = "{:%A, %B %d %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "cpu" = {
          format = " 󰻠 {usage}%";
          interval = 1;
        };

        "memory" = {
          format = " 󰘚 {}%";
          interval = 2;
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        "network" = {
          on-click = "kitty --title nmtui -e nmtui";
          format-wifi = "󰤨 {essid}";
          format-disconnected = "󰤭 disconnected";
          tooltip = true;
          tooltip-text = "{signalStrength}%";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 muted";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
        };

        "mpris" = {
          format = "{player_icon} {title} - {artist}";
          format-paused = " {title} - {artist}";
          player-icons = {
            default = "▶";
            spotify = "";
          };
          max-length = 40;
        };

        "custom/power" = {
          format = "⏻";
          on-click = "wlogout";
          tooltip = false;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: rgba(14, 14, 18, 0.9);
        color: #cdd6f4;
      }

      .modules-left, .modules-right, .modules-center {
        margin: 4px 8px;
      }

      #workspaces button {
        padding: 0 4px;
        color: #6c7086;
        background: transparent;
      }

      #workspaces button.active {
        color: #cba6f7;
      }

      #clock {
        color: #cdd6f4;
        padding: 0 10px;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.warning {
        color: #fab387;
      }

      #battery.critical {
        color: #f38ba8;
      }

      #network {
        color: #89dceb;
      }

      #tray {
        padding: 0 8px;
      }

      #pulseaudio {
        color: #f5c2e7;
      }

      #backlight {
        color: #f9e2af;
      }

      #cpu {
        color: #89b4fa;
      }

      #memory {
        color: #a6e3a1;
      }

      #mpris {
        color: #cba6f7;
      }

      #custom-power {
        color: #f38ba8;
        padding: 0 8px;
        margin-right: 4px;
      }
    '';
  };
}
