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

}
