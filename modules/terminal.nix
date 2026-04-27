{ config, pkgs, ... }:

{
  
  programs.starship = {
      enable = true;
      settings = {
          add_newline = false;
          character = {
              success_symbol = "[->](bold green)";
              error_symbol = "[->](bold #d20f39)";
          };
          directory = {
              style = "bold #89b4d4";
              truncation_length = 3;
              truncate_to_repo = true;
          };

          git_branch = {
              style = "bold #c478b4";
              symbol = " ";
          };

          git_status = {
              style = "bold #e8943a";
          };

          cmd_duration = {
              style = "bold #7ab648";
              min_time = 2000;
          };

          username = {
              style_user = "bold #e8789a";
              show_always = false;
          };
      };
  };

  programs.kitty = {
      enable = true;
      font = {
          name = "JetBrainsMono Nerd Font";
          size = 13;
      };
      settings = {
        # Colors
        background = "#1a1a2e";
        foreground = "#d4cdb8";
        cursor = "#e8789a";
        selection_background = "#e8789a";
        selection_foreground = "#1a1a2e";

        # Normal colors
        color0 = "#1a1a2e";
        color1 = "#e8789a";
        color2 = "#7ab648";
        color3 = "#e8943a";
        color4 = "#89b4d4";
        color5 = "#c478b4";
        color6 = "#6a9ec4";
        color7 = "#d4cdb8";

        # Bright colors
        color8 = "#16213e";
        color9 = "#e8789a";
        color10 = "#7ab648";
        color11 = "#e8943a";
        color12 = "#89b4d4";
        color13 = "#c478b4";
        color14 = "#6a9ec4";
        color15 = "#d4cdb8";

        # Window
        window_padding_width = 8;
        hide_window_decorations = "yes";
        background_opacity = "0.95";

        # Misc
        confirm_on_close = "never";
        enable_audio_bell = "no";
        tab_bar_style = "powerline";
      };
  };
}
