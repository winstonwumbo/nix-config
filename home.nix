{
  lib,
  config,
  pkgs,
  nixgl,
  ...
}:
let 
  gtkTheme = "Qogir-Dark";
  gtkThemePkg = (pkgs.qogir-theme.override {
    themeVariants = [ "default" ];
    colorVariants = [ "dark" ];
  });
in
{
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can split up your configuration and import pieces of it here:
    ./modules/apps.nix
    ./modules/devtools.nix
    ./modules/nvim.nix
    ./modules/sectools.nix
    ./modules/sysutils.nix
    ./modules/terminal.nix
    ./modules/vscode.nix
  ];

  # generic: global settings
  targets.genericLinux = {
    enable = true;
    # GPU wrapper for non-Nix distros
    nixGL = {
      packages = nixgl.packages;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };
  };

  services.flatpak = {
    enable = true;
    uninstallUnused = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };

  services.flatpak.overrides = {
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
  };

  fonts.fontconfig.enable = true;

  # HM: static "system" info
  home = {
    username = "ruyu";
    homeDirectory = "/var/home/ruyu";
    # This value determines the Home Manager release that your configuration is
    # compatible with. You should not change this value, even if you update Home Manager.
    # If you do want to update the value, then make sure to first check the release notes.
    stateVersion = "25.05";

    # Mirror .desktop files to a writeable dir for update-desktop-database
    activation.mirrorDesktopEntries = lib.hm.dag.entryAfter ["installPackages"] ''
      if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then

        if [ ! -d "${config.home.homeDirectory}/.local/share/applications" ]; then
          mkdir "${config.home.homeDirectory}/.local/share/applications"
        fi

        # Remove broken symlinks from previous runs
        find "${config.home.homeDirectory}/.local/share/applications" \
          -maxdepth 1 -name "*.desktop" -xtype l -delete

        # Symlink each .desktop file individually
        for file in "${config.home.homeDirectory}/.nix-profile/share/applications"/*.desktop; do
          target="${config.home.homeDirectory}/.local/share/applications/$(basename "$file")"
          [ ! -L "$target" ] && ln -sf "$file" "$target"
        done

      fi
    '';
  };

  # HM: DE packages
  home.packages = with pkgs; [
    # Gnome shell theme
    (pkgs.marble-shell-theme.override {
      colors = [ "blue" ];
      additionalInstallationTweaks = [
        "-Pnp"
        "--hue=220"
        "--name=gnomeblue"
        "--mode=dark"
        "--filled"
        "-O"
        "--sat=80"
      ];
    })

    nerd-fonts.jetbrains-mono
    gnome-tweaks

    # Gnome extensions
    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-panel
    gnomeExtensions.arcmenu
    gnomeExtensions.caffeine
    # Maintained by Ubuntu
    gnomeExtensions.appindicator
    # Maintained by Gnome
    # gnomeExtensions.auto-move-windows
    ffmpegthumbnailer
  ];

  # HM symlinks: creates a copy of 'dotfiles/blank' in the Nix store.
  home.file = {
    # Themeing
    ".local/share/icons/Numix".source = "${pkgs.numix-icon-theme-circle}/share/icons/Numix";
    ".local/share/icons/Numix-Light".source = "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Light";
    ".local/share/icons/Numix-Circle".source =
      "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Circle";
    ".local/share/icons/Numix-Circle-Light".source =
      "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Circle-Light";
    ".local/share/themes/${gtkTheme}".source = "${gtkThemePkg}/share/themes/${gtkTheme}"; 

    ".local/bin/bwrap" = { 
        text = ''
        #!/usr/bin/env bash
        nix_args=()
        if [[ " $* " == *" GIO_USE_VFS "* ]]; then
            profile="$(realpath "$HOME")/.nix-profile"
            [[ -d "$profile"   ]] && nix_args+=(--ro-bind "$profile" "$profile")
            [[ -d /nix/store   ]] && nix_args+=(--ro-bind /nix/store /nix/store)
        fi
        exec /usr/bin/bwrap "''${nix_args[@]}" "$@"
      '';
      executable = true;
    };
    ".local/share/thumbnailers/totem.thumbnailer".text = ''
      [Thumbnailer Entry]
      TryExec=ffmpegthumbnailer
      Exec=ffmpegthumbnailer -i %i -o %o -s %s -f
      MimeType=video/3gpp;video/3gpp2;video/annodex;video/dv;video/isivideo;video/mj2;video/mp2t;video/mp4;video/mpeg;video/ogg;video/quicktime;video/vnd.avi;video/vnd.mpegurl;video/vnd.radgamettools.bink;video/vnd.radgamettools.smacker;video/vnd.rn-realvideo;video/vnd.vivo;video/vnd.youtube.yt;video/wavelet;video/webm;video/x-anim;video/x-flic;video/x-flv;video/x-javafx;video/x-matroska;video/x-matroska-3d;video/x-mjpeg;video/x-mng;video/x-ms-wmv;video/x-nsv;video/x-ogm+ogg;video/x-sgi-movie;video/x-theora+ogg;application/mxf;application/vnd.ms-asf;application/vnd.rn-realmedia;application/x-matroska;application/ogg;
    '';
  };

  # GTK: theme and icons
  gtk = {
    enable = true;

    theme = {
      name = gtkTheme;
      package = gtkThemePkg;
    };

    iconTheme = {
      name = "Numix-Circle";
      package = pkgs.numix-icon-theme-circle;
    };

    # GTK3 theme is no longer mirrored to GTK4 with home-manager 26.05
    gtk4.theme = config.gtk.theme;
  };

  # dconf: mostly keybinds
  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "arcmenu@arcmenu.com"
        "dash-to-panel@jderose9.github.com"
        "caffeine@patapon.info"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Marble-gnomeblue-dark";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [
        "<Alt>F4"
        "<Super>q"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      www = [ "<Super>b" ];
      # Leading slashs are absolutely necessary for custom-keybinds, Gnome crashes otherwise
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    # Can't nest - dconf is weird with a relocatable schema thing for custom keybinds
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open Terminal";
      command = "wezterm start --cwd .";
      binding = "<Super>t";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Open Nautilus/File Explorer";
      command = "nautilus";
      binding = "<Super>e";
    };
  };


  # Makes writing dotfiles to ~/.config that little bit shorter
  xdg.configFile = {
    "autostart/login-sound.desktop".source = dotfiles/managed/autostart/login-sound.desktop;
  };

  # # You can also create simple shell scripts directly inside your
  # # configuration. For example, this adds a command 'my-hello' to your
  # # environment:
  # (pkgs.writeShellScriptBin "my-hello" ''
  #   echo "Hello, ${config.home.username}!"
  # '')

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
