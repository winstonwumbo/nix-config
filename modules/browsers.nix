{ config, pkgs, ... }:
{
  programs.brave = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.brave);
    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin
    ];
  };

  xdg.configFile."brave-flags.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "../dotfiles/brave-flags.conf";
  };
}