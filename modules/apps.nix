{ ... }:
{
  # Module: desktop applications
  services.flatpak.packages = [
    # Browsers
    "com.brave.Browser" # Blink (Chromium)
    "io.gitlab.librewolf-community" # Gecko (Firefox)
    "org.gnome.Epiphany" # Webkit (Kinda Safari)
    "org.ferdium.Ferdium" # Webapps
    # Media
    "io.github.celluloid_player.Celluloid" # Video Player
    "com.github.neithern.g4music" # Music
    "org.tenacityaudio.Tenacity" # Audio
    "com.obsproject.Studio" # Video Recording
    "org.kde.kdenlive" # Video Editing

    "io.gitlab.news_flash.NewsFlash" # RSS
    "info.febvre.Komikku" # Manga
    "com.github.johnfactotum.Foliate" # Ebooks
    "com.github.PintaProject.Pinta" # Paint
    "io.github.josephmawa.Bella" # Color Picker
    "com.github.tenderowl.frog" # OCR
    # Productivity
    "org.onlyoffice.desktopeditors" # Office
    "org.kde.okular" # PDFs
    "md.obsidian.Obsidian" # Notes
    "org.gnome.Evolution" # Email
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
