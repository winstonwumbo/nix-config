{pkgs, ...}: {
  services.flatpak = {
    enable = true;
    uninstallUnused = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    packages = [
      # Theme
      "org.gtk.Gtk3theme.adw-gtk3-dark"
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
      global = {
        Context = {
          filesystems = [
            "/nix/store:ro"
          ];
        };
      };
    };
  };
}