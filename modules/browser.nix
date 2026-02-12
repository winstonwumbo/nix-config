{ config, pkgs, ... }:
{
  programs.vivaldi = {
    enable = true;
    package = config.lib.nixGL.wrap (pkgs.vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = false;
    });
    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin lite
      { id = "dlnejlppicbjfcfcedcflplfjajinajd"; } # bonjourr
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
    ];
    commandLineArgs = [
      "--ozone-platform-hint=auto"
    ];
    # Manually activate #middle-click-autoscroll in brave://flags.
    # --enable-blink-features=MiddleClickAutoscroll works but w/ unsupported banner every launch
  };
}