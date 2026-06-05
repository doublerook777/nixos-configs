{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 12";
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#cba6f7";
      border-radius = 8;
      border-size = 2;
      padding = "10,14";
      margin = "8";
      width = 320;
      height = 100;
      default-timeout = 5000;

      # urgency colors
      "[urgency=high]" = {
        border-color = "#f38ba8";
        default-timeout = 0;  # stays until dismissed
      };
    };
  };
}
