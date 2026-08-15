{ config, pkgs, inputs, ... }:

{
  imports = [
      ./modules/niri.nix
      ./modules/waybar.nix
      ./modules/terminal.nix
      ./modules/mako.nix
      ./modules/tldraw.nix
      ./modules/rofi.nix
  ];

  home.username = "caelum";
  home.homeDirectory = "/home/caelum";
  home.stateVersion = "26.05";
  programs.bash = {
	    enable = true;
      enableCompletion = true;
      initExtra = ''
          bind "set show-all-if-ambiguous on"
          bind 'TAB: menu-complete'
          bind '"\e[Z": menu-complete-backward'
          bind "set completion-ignore-case on"
          bind "set colored-stats on"

          rebuild() {
              cd ~/nixos-configs || return 1
              git add -A
              git add -f files/
              trap 'git reset files/ >/dev/null' RETURN
              sudo nixos-rebuild switch --flake ~/nixos-configs#caelums-nix
          }
      '';
	    shellAliases = {
	        hcheck = "echo looks good";
	        update = "sudo nix flake update --flake ~/nixos-configs";
          clean = "sudo nix-collect-garbage -d";
          clean-complete = "sudo nix-collect-garbage -d --option keep-outputs false --option keep-derivations false";
          ls = "eza --icons --color=always";
          ll = "eza -l --icons --color=always";
          la = "eza -la --icons --color=always";
          lt = "eza --tree --icons --color=always";
	        vim = "nvim";
          pkgmgr = "bash ~/nixos-configs/scripts/pkgmgr.sh";
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

  xdg.desktopEntries.yazi = {
      name = "yazi";
      genericName = "Files";
      exec = "kitty yazi";
      terminal = false;
      icon = "yazi";
      categories = [ "Utility" "Core" "System" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
     "image/png" = "org.gnome.Loupe.desktop";
     "image/jpeg" = "org.gnome.Loupe.desktop";
     "image/gif" = "org.gnome.Loupe.desktop";
     "image/webp" = "org.gnome.Loupe.desktop";
     "image/bmp" = "org.gnome.Loupe.desktop";
     "image/tiff" = "org.gnome.Loupe.desktop";
    };
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

  # thunar theme
  gtk = {
    enable = true;

    # A clean, universally compatible dark theme
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    # A beautiful, modern icon set with clear dark-mode folder variants
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

  };

  catppuccin.enable = true;
  catppuccin.autoEnable = true;
  catppuccin.gtk.icon.enable = false; # or else will collide with thunar's gtk theme
  catppuccin.cursors = {
    enable = true;
    accent = "dark";
    flavor = "mocha";
  };

  # Force Wayland apps to recognize the GTK theme immediately
  home.sessionVariables = {
    GTK_THEME = "Adwaita-dark";
    EDITOR = "nvim";
    XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    XCURSOR_SIZE = "24";
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.libnotify}/bin/notify-send 'Locking soon' -t 5000";
      }
      {
        timeout = 305;
        command = "qylock-lock";
      }
      {
        timeout = 600;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      {
        timeout = 1800;
        command = "${pkgs.systemd}/bin/systemctl hibernate";
      }
    ];
    events = {
      before-sleep = "qylock-lock";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Tweak Thunar preferences cleanly via xfconf
  xfconf.settings.thunar = {
    "last-view" = "ThunarDetailsView";          # Clean list view (or use ThunarIconView)
    "last-side-pane" = "ThunarShortcutsPane";   # Keeps your sidebar active
    "misc-single-click" = false;                # Double-click to open files (standard behavior)
    "misc-menubar-visible" = false;             # Hides the ugly top menu bar (Press 'Ctrl + M' to toggle it back if needed!)
    "misc-draw-border-around-images" = false;   # Borderless look for images
  };

  home.packages = with pkgs; [
    localsend
    thunar
    fd
    basedpyright                                # LSP for python
    ruff                                        # code formatter for python
    fzf
    foliate
    inputs.sidra.packages.${pkgs.system}.default
  ];

}
