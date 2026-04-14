{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nmap
    zap
    (config.lib.nixGL.wrap burpsuite)
    ghidra
    detect-it-easy
  ];

  home.shellAliases = {
    snmap = "sudo ${config.home.homeDirectory}/.nix-profile/bin/nmap";
  };

  services.flatpak.packages = [
    "com.yubico.yubioath"
    "io.ente.auth"
    "org.cryptomator.Cryptomator"
    "net.werwolv.ImHex"
    "org.wireshark.Wireshark"
    "io.emeric.toolblex"
  ];
    
  services.flatpak.overrides = {
    "org.wireshark.Wireshark" = {
      Context = {
        # Wireshark cannot export CSVs without write access
        filesystems = [
          "home"
        ];
      };
    };

    "io.emeric.toolblex" = {
      Context = {
        sockets = [
          "!wayland"
        ];
      };
    };
  };
}
