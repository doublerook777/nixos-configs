{ config, pkgs, ... }:

{
  services.mako.enable = true;

  xdg.configFile."mako/config".text = ''
    font=JetBrainsMono Nerd Font 12
    background-color=#1e1e2eFF
    text-color=#cdd6f4FF
    border-color=#cba6f7FF
    border-radius=8
    border-size=2
    padding=10,14
    margin=8
    width=320
    height=100
    default-timeout=5000
    anchor=top-right
    layer=overlay

    [urgency=low]
    border-color=#89b4faFF

    [urgency=critical]
    border-color=#f38ba8FF
    default-timeout=0
  '';
}
