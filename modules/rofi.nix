{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.kitty}/bin/kitty";
  };

  xdg.configFile."rofi/context-menu.rasi".text = ''
    configuration {
      show-icons: false;
    }

    * {
      font: "JetBrainsMono Nerd Font 12";
    }

    window {
      width: 240px;
      location: center;
      anchor: center;
      transparency: "real";
      border-radius: 12px;
      background-color: rgba(28, 48, 56, 0.9);
      border: 2px;
      border-color: #f68bcf;
      padding: 8px;
    }

    mainbox {
      children: [ "listview" ];
    }

    listview {
      lines: 6;
      spacing: 4px;
      fixed-height: false;
      scrollbar: false;
    }

    entry {
      enabled: false;
    }

    element {
      padding: 8px 12px;
      border-radius: 8px;
      text-color: #e8f1d8;
    }

    element selected {
      background-color: #f68bcf;
      text-color: #1c3038;
    }
  '';
}
