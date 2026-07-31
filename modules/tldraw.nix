{ config, pkgs, ... }:

let
  tldraw-offline = pkgs.appimageTools.wrapType2 {
    pname = "tldraw-offline";
    version = "1.0.0";
    src = ../files/tldraw-offline-linux-x86_64.AppImage;
    extraPkgs = pkgs: with pkgs; [ ];
  };
in
{
  home.packages = [ tldraw-offline ];

  xdg.desktopEntries.tldraw-offline = {
    name = "tldraw";
    genericName = "Whiteboard";
    exec = "tldraw-offline";
    terminal = false;
    icon = "tldraw-offline";
    categories = [ "Graphics" "Office" ];
  };
}
