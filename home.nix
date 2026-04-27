{ config, pkgs, ... }:

{
  imports = [
      ./modules/niri.nix
      ./modules/waybar.nix
  ];

  home.username = "caelum";
  home.homeDirectory = "/home/caelum";
  home.stateVersion = "25.11";
  programs.bash = {
	    enable = true;
	    shellAliases = {
	        hcheck = "echo looks good";
	        rebuild = "sudo nixos-rebuild switch --flake ~/nixos-configs#caelums-nix";
	        update = "sudo nix flake update ~/nixos-configs";
          clean = "nix-collect-garbage -d";
	    };
  };

  programs.wlogout = {
      enable = true;
      layout = [
        { label = "shutdown"; text = "Shutdown"; keybind = "s"; action = "systemctl poweroff"; }
        { label = "reboot"; text = "Reboot"; keybind = "r"; action = "systemctl reboot"; }
        { label = "logout"; text = "Logout"; keybind = "l"; action = "niri msg action quit"; }
      ];
  };

  programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
  };
}
