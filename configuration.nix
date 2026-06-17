# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  # Use GRUB
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 10;


  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "caelum-nix"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  
  # wifi optimizations
  environment.etc."NetworkManager/conf.d/wifi.conf".text = ''
    [connection]
    wifi.powersave = 2
    wifi.cloned-mac-address=permanent

    [device]
    wifi.scan-rand-mac-address=no
  '';
  networking.nameservers = ["8.8.8.8" "1.1.1.1"];

  #for local send
  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
  
  # Enable hybernation using swap 
  swapDevices = [
      { device = "/swapfile"; size = 8192; }
  ];

  boot.resumeDevice = "/dev/nvme0n1p8";
  boot.kernelParams = [ 
      "resume_offset=22482944"
      "mem_sleep_default=deep"
  ];

  systemd.sleep.settings.Sleep = {
      HibernateMode = "platform shutdown";
      HibernateDelaySec = "30m";
  };

  # Enable niri
  programs.niri.enable = true;
  
  # XDG portals
  xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
  
  # Wayland session variables
  environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    extraPackages = with pkgs; [
      qt6.qt5compat
      kdePackages.qt5compat
    ];
    settings = {
      General = {
        GreeterEnvironment = "QML2_IMPORT_PATH=${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.kdePackages.qt5compat}/lib/qt-6/qml";
      };
    };
  };
  programs.qylock = {
    enable = true;
    theme = "sword";
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # pipewire for high-res auddio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
  
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };
    };
  };
    
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.caelum = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # Enable Thunar service natively
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin # Allows right-click "Extract Here"
      thunar-volman         # Manages removable drives
    ];
  };

  # battery optimizations
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;  # tune to taste };
    };
  };

  # Essential background services for a standalone window manager setup
  services.gvfs.enable = true;    # Fixes Trash, Network shares, and USB mounting
  services.tumbler.enable = true; # Enables image and file thumbnails

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add common libraries your binary might need here
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  programs.firefox.enable = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    niri
    eza
    waybar
    fuzzel
    kitty
    grim
    wl-clipboard
    brightnessctl
    playerctl
    xwayland-satellite
    vim
    wget
    neovim
    brave
    git
    gcc
    ripgrep
    curl
    wlogout
    blueman
    qalculate-gtk
    yazi
    starship
    mpv
    awww
    strawberry
    nh
    fastfetch
    vesktop
    cheese
    dust
    duf
    usbutils
    pciutils
    qt6.qtmultimedia
    gnome-clocks
    gnome-calendar
    btop
    obs-studio
    unzip
    zip
    p7zip
    gnutar
    bash-completion
    python3
    uv
    libnotify
    qt6.qt5compat
    loupe
    powertop
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Enabling Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

