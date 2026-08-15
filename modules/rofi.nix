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
        kb-row-up: "Up,k,Control+p";
        kb-row-down: "Down,j,Control+n";
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

  xdg.configFile."rofi/wallpaper-picker.rasi".text = ''
      configuration {
        show-icons: true;
        kb-row-up: "Up,k,Control+p";
        kb-row-down: "Down,j,Control+n";
        kb-row-left: "h";
        kb-row-right: "l";
      }

      * {
        font: "JetBrainsMono Nerd Font 11";
        background-color: transparent;
        text-color: #e8f1d8ff;
      }

      window {
        width: 780px;
        location: center;
        anchor: center;
        transparency: "real";
        border-radius: 12px;
        background-color: #1c3038e6;
        border: 2px;
        border-color: #f68bcfff;
        padding: 16px;
      }

      mainbox {
        background-color: transparent;
        children: [ "inputbar", "listview" ];
        spacing: 10px;
      }

      inputbar {
        background-color: #16283000;
        border: 1px;
        border-color: #f68bcf80;
        border-radius: 8px;
        padding: 8px 12px;
        children: [ "prompt", "entry" ];
      }

      prompt {
        text-color: #e8f1d8ff;
      }

      entry {
        placeholder: "Search wallpapers...";
        placeholder-color: #4a4f3bbf;
        text-color: #e8f1d8ff;
      }

      listview {
        background-color: transparent;
        columns: 3;
        lines: 2;
        spacing: 14px;
        fixed-height: false;
        scrollbar: false;
      }

      element {
        background-color: transparent;
        orientation: vertical;
        padding: 6px;
        border-radius: 10px;
        width: 232px;
        height: 160px;
      }

      element selected {
        background-color: #45475acc;
        border-radius: 10px;
      }

      element-icon {
        size: 232px;
        horizontal-align: 0.5;
        vertical-align: 0.5;
      }

      element-text {
        horizontal-align: 0.5;
        text-color: #e8f1d8ff;
        font: "JetBrainsMono Nerd Font 9";
      }
  '';
}
