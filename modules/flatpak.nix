{pkgs, ...}: {
  services.flatpak = {
    enable = true;
    uninstallUnused = true;
    update.onActivation = true;
    packages = [
      # Sysadmin
      "com.github.tchx84.Flatseal"
      "ca.desrt.dconf-editor"
      "io.github.flattool.Warehouse"
      "org.wireshark.Wireshark"
      "io.podman_desktop.PodmanDesktop"
      # Media
      "io.github.celluloid_player.Celluloid"
      "com.obsproject.Studio"
      "org.kde.kdenlive"
      "com.github.wwmm.easyeffects"
      "com.github.neithern.g4music"
      "org.tenacityaudio.Tenacity"
      "info.febvre.Komikku"
      "com.github.johnfactotum.Foliate"
      # Productivity
      "org.onlyoffice.desktopeditors"
      "org.kde.okular"
      "md.obsidian.Obsidian"
      "com.github.jeromerobert.pdfarranger"
    ];

    overrides = {
      global.Context = {
        filesystems = [
          "/nix/store:ro"
          "/var/home/ruyu/.nix-profile/share/icons:ro"
          "/var/home/ruyu/.nix-profile/share/icons/Numix-Circle:ro"
          "/var/home/ruyu/.nix-profile/share/icons/Numix-Circle-Light:ro"
          "/var/home/ruyu/.nix-profile/share/icons/Numix:ro"
          "/var/home/ruyu/.nix-profile/share/icons/Numix-Light:ro"
          "/nix/var/nix/profiles/default/share:ro"
          "/usr/share/icons:ro"
          "~/.local/share/icons:ro"
        ];
      };
    };
  };
}