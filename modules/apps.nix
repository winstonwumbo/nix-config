{ ... }:
{
  # Desktop applications
  services.flatpak.packages = [
    # Browsers
    "com.brave.Browser" # Blink (Chromium)
    "io.gitlab.librewolf-community" # Gecko (Firefox)
    "org.gnome.Epiphany" # Webkit (Kinda Safari)
    "org.ferdium.Ferdium" # Webapps
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
  ];

  services.flatpak.overrides = {
    "org.kde.kdenlive" = {
      Environment = {
        # UI gets cutoff on my T480 screen
        QT_SCALE_FACTOR = "0.8";
      };
    };
  };
}
