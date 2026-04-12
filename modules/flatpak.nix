{ pkgs, ... }:
{
  services.flatpak = {
    enable = true;
    uninstallUnused = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    packages = [
      # Browsers
      "com.brave.Browser" # Blink (Chromium)
      "io.gitlab.librewolf-community" # Gecko (Firefox)
      "org.gnome.Epiphany" # Webkit (Kinda Safari)
      "org.ferdium.Ferdium" # Webapps
      # Sysadmin
      "com.github.tchx84.Flatseal"
      "ca.desrt.dconf-editor"
      "org.gnome.seahorse.Application"
      "io.github.flattool.Warehouse"
      "com.github.wwmm.easyeffects"
      "dev.serebit.Waycheck"
      "io.missioncenter.MissionCenter"
      "net.nokyan.Resources"
      # Media
      "io.github.celluloid_player.Celluloid"
      "com.github.neithern.g4music"
      "org.tenacityaudio.Tenacity"
      "io.gitlab.news_flash.NewsFlash" # RSS
      "info.febvre.Komikku" # Manga
      "com.github.johnfactotum.Foliate" # Ebooks
      "com.github.PintaProject.Pinta"
      "io.github.josephmawa.Bella"
      "com.github.tenderowl.frog"
      "com.obsproject.Studio"
      "org.kde.kdenlive"
      # Productivity
      "org.onlyoffice.desktopeditors"
      "org.kde.okular"
      "md.obsidian.Obsidian"
      "org.gnome.Evolution"
      "com.github.jeromerobert.pdfarranger"
      # Devtools
      "org.virt_manager.virt-manager" # Manually select QEMU/System session after install
      "io.podman_desktop.PodmanDesktop"
      # Sectools
      "com.bitwarden.desktop"
      "com.yubico.yubioath"
      "io.ente.auth"
      "org.cryptomator.Cryptomator"
      "net.werwolv.ImHex"
      "org.wireshark.Wireshark"
      "io.emeric.toolblex"
    ];

    overrides = {
      global = {
        Context = {
          filesystems = [
            "/nix/store:ro"
            "xdg-data/themes:ro"
            "xdg-config/gtk-3.0:ro"
            "xdg-config/gtk-4.0:ro"
          ];
        };
        Environment = {
          GTK_THEME = "Qogir-Dark";
        };
      };

      "org.kde.kdenlive" = {
        Environment = {
          # UI gets cutoff on my T480 screen
          QT_SCALE_FACTOR = "0.8";
        };
      };

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
  };
}
