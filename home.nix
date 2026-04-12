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
    ./modules/devtools.nix
    ./modules/flatpak.nix
    ./modules/nvim.nix
    ./modules/sysutils.nix
    ./modules/terminal.nix
    ./modules/vscode.nix
  ];

  # Generic
  targets.genericLinux = {
    enable = true;
    # GPU wrapper for non-Nix distros
    nixGL = {
      packages = nixgl.packages;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
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
  ];

  # HM symlinks: creates a copy of 'dotfiles/blank' in the Nix store.
  home.file = {
    ".local/share/icons/Numix".source = "${pkgs.numix-icon-theme-circle}/share/icons/Numix";
    ".local/share/icons/Numix-Light".source = "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Light";
    ".local/share/icons/Numix-Circle".source =
      "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Circle";
    ".local/share/icons/Numix-Circle-Light".source =
      "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Circle-Light";
    ".local/share/themes/${gtkTheme}".source = "${gtkThemePkg}/share/themes/${gtkTheme}"; 

    # Sets default terminal for .desktop shortcuts on Gnome
    # See: https://github.com/ublue-os/main/issues/211#issuecomment-1551600704
    # Also see: https://discussion.fedoraproject.org/t/fedora-terminal-and-alternatives/106438
    ".local/bin/xdg-terminal-exec".source = dotfiles/managed/terminal/xdg-terminal-exec;
  };

  # GTK theme and icons
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
