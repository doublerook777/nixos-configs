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
        background-color: transparent;
        text-color: #e8f1d8ff;
      }

      window {
        width: 240px;
        location: center;
        anchor: center;
        transparency: "real";
        border-radius: 12px;
        background-color: #1c3038e6;
        border: 2px;
        border-color: #f68bcfff;
        padding: 15px 12px;
      }

      mainbox {
        background-color: transparent;
        children: [ "listview" ];
      }

      listview {
        background-color: transparent;
        lines: 6;
        spacing: 4px;
        fixed-height: false;
        scrollbar: false;
      }

      entry {
        enabled: false;
      }
 
      element {
        background-color: transparent;
        padding: 8px 12px;
        border-radius: 10px;
        text-color: #e8f1d8ff;
      }

      element selected {
        background-color: #f68bcfcc;
        text-color: #1c3038ff;
        border-radius: 10px;
      }
  '';
}
