# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.silentSDDM.nixosModules.default
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
    wifi.powrsave = 2
    wifi.cloned-mac-address=permanent

    [device]
    wifi.scan-rand-mac-address=no
  '';
  networking.nameservers = ["8.8.8.8" "1.1.1.1"];

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

  systemd.sleep.extraConfig = ''
      HibernateMode=platform shutdown
      HibernateDelaySec=30m
  '';

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
  programs.silentSDDM = {
      enable = true;
      theme = "default";
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
  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

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

  programs.firefox.enable = true;
  
   # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    niri
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
    swww
    mpv
    strawberry
    nh
    fastfetch
    vesktop
    cheese
    dust
    duf
    usbutils
    pciutils
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Enabling Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

