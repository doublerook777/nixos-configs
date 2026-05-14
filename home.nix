{ config, pkgs, ... }:

{
  imports = [
      ./modules/niri.nix
      ./modules/waybar.nix
      ./modules/terminal.nix
  ];

  home.username = "caelum";
  home.homeDirectory = "/home/caelum";
  home.stateVersion = "25.11";
  programs.bash = {
	    enable = true;
      enableCompletion = true;
      initExtra = ''
          bind "set show-all-if-ambiguous on"
          bind 'TAB: menu-complete'
          bind '"\e[Z": menu-complete-backward'
          bind "set completion-ignore-case on"
          bind "set colored-stats on"
      '';
	    shellAliases = {
	        hcheck = "echo looks good";
	        rebuild = "sudo nixos-rebuild switch --flake ~/nixos-configs#caelums-nix";
	        update = "sudo nix flake update path:/home/caelum/nixos-configs";
          clean = "nix-collect-garbage -d";
	    };
  };

  programs.git = {
      enable = true;
      settings = {
          user = {   
              userName = "caelum";
              userEmail = "sjgupta30@gmail.com";
          };
      };
  };

  programs.wlogout = {
      enable = true;
      layout = [
        { label = "shutdown"; text = "Shutdown"; keybind = "s"; action = "systemctl poweroff"; }
        { label = "reboot"; text = "Reboot"; keybind = "r"; action = "systemctl reboot"; }
        { label = "logout"; text = "Logout"; keybind = "l"; action = "niri msg action quit"; }
        { label = "hibernate"; text = "Hibernate"; keybind = "h"; action = "systemctl hibernate"; }
      ];
  };

  programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
  };

  xdg.desktopEntries.yazi = {
      name = "yazi";
      genericName = "Files";
      exec = "kitty yazi";
      terminal = false;
      icon = "yazi";
      categories = [ "Utility" "Core" "System" ];
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        terminal = "kitty";
        prompt = "'  '";
        # ensures the cursor starts after the icon
        letter-spacing = 0;
        # Set layer to overlay for Wayland integration on Niri
        layer = "overlay";
        # Disable icons
        show-icons = "no";
        # Layout parameters
        width = 30;
        lines = 10;
        vertical-padding = 15;
        horizontal-padding = 12;
        anchor = "center";
        match-mode = "fuzzy";
      };
  
      colors = {
        background = "1c3038e6";
        text = "e8f1d8ff";
        match = "89dcebff";
        # Total Selection: #e87e14 (orange base) + 'cc' (80% opacity)
        selection = "f68bcfcc";
        # TEXT on Active Selection (Dark base color)
        selection-text = "1c3038ff";
        # Subtle BORDER color
        # Lightly transparent 'bf' (75% opacity)
        border = "f68bcfff";
        # Placeholder/subtle text color
        placeholder = "4a4f3bbf";
        selection-radius = 10;
      };
  
      border = {
        width = 2;
        radius = 12;
      };
      
      dmenu = {
        exit-immediately-if-empty = "yes";
      };
    };
  };

}
