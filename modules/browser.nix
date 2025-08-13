{ config, pkgs, ... }:
{
  programs.brave = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.brave);
    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin
      { id = "dlnejlppicbjfcfcedcflplfjajinajd"; } # bonjourr
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
    ];
    commandLineArgs = [
      "--enable-features=TouchpadOverscrollHistoryNavigation"
      "--ozone-platform-hint=auto"
    ];
    # Manually activate #middle-click-autoscroll in brave://flags.
    # --enable-blink-features=MiddleClickAutoscroll works but w/ unsupported banner every launch
  };
}