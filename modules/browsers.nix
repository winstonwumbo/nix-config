{ config, pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.brave);
    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin
    ];
  }
}