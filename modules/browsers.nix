{ config, pkgs, ... }:
{
  programs.brave = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.brave);
    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin
    ];
    commandLineArgs = [
      "--enable-features=TouchpadOverscrollHistoryNavigation"
      "--enable-blink-features=MiddleClickAutoscroll"
      "--ozone-platform-hint=auto"
    ];
  };
}