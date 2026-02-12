{
  lib,
  config,
  pkgs,
  nixgl,
  ...
}:

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
    ./modules/terminal.nix
    ./modules/vscode.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ruyu";
  home.homeDirectory = "/var/home/ruyu";

  # This value determines the Home Manager release that your configuration is
  # compatible with. You should not change this value, even if you update Home Manager.
  # If you do want to update the value, then make sure to first check the release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  targets.genericLinux = {
    enable = true;
    nixGL = {
      packages = nixgl.packages;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };
  };

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages
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
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.caffeine
    # Maintained by Ubuntu
    gnomeExtensions.appindicator
    # Maintained by Gnome
    #     gnomeExtensions.auto-move-windows
    # gtk-engine-murrine
    # sassc
  ];

  # # You can also create simple shell scripts directly inside your
  # # configuration. For example, this adds a command 'my-hello' to your
  # # environment:
  # (pkgs.writeShellScriptBin "my-hello" ''
  #   echo "Hello, ${config.home.username}!"
  # '')

  # Gnome theme and settings
  gtk = {
    enable = true;

    # theme = {
    #   name = "Graphite-blue-compact-nord";
    #   package = (pkgs.graphite-gtk-theme.override {
    #     themeVariants = [ "blue" ];
    #     colorVariants = [ "standard" ];
    #     sizeVariants = [ "compact" ];
    #     tweaks = [ "normal" "nord"];
    #   });
    # };

    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Numix-Circle";
      package = pkgs.numix-icon-theme-circle;
    };
  };

  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "arcmenu@arcmenu.com"
        "dash-to-panel@jderose9.github.com"
        "rounded-window-corners@fxgn"
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

  # Fish shell configuration
  programs.fish = {
    enable = true;
    shellAliases = {
      nix-update = "cd ${config.home.homeDirectory}/.config/nix-config && nix flake update && cd -";
      nix-upgrade = "home-manager switch";
      nix-edit = "code ${config.home.homeDirectory}/.config/nix-config";
      nix-autoclean = "nix-collect-garbage --delete-older-than 14d";
      frun = "flatpak run";
      ssmartctl = "sudo ${config.home.homeDirectory}/.nix-profile/bin/smartctl";
      sncdu = "sudo ${config.home.homeDirectory}/.nix-profile/bin/ncdu";
      snmap = "sudo ${config.home.homeDirectory}/.nix-profile/bin/nmap";
    };
    shellInit = ''
      set fish_greeting # Disable greeting

      mise activate fish | source

      fish_add_path --global ${config.home.homeDirectory}/.yarn/bin
    '';
  };

  # If you don't want to manage your shell through Home Manager
  # then you have to manually source 'hm-session-vars.sh'
  home.sessionVariables = {
    # EDITOR = "emacs";
    DOCKER_CONFIG = "${config.home.homeDirectory}/.config/docker";
    NIXOS_OZONE_WL = "1";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock";
  };

  # My symlinks: the primary way to manage plain files is through 'home.file'.
  # Building this configuration will create a copy of 'dotfiles/blank' in the Nix store.
  home.file = {
    ".local/share/icons/Numix".source = "${pkgs.numix-icon-theme-circle}/share/icons/Numix";
    ".local/share/icons/Numix-Light".source = "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Light";
    ".local/share/icons/Numix-Circle".source =
      "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Circle";
    ".local/share/icons/Numix-Circle-Light".source =
      "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Circle-Light";

    # Sets default terminal for Gnome .desktop shortcuts
    # See: https://github.com/ublue-os/main/issues/211#issuecomment-1551600704
    # Also see: https://discussion.fedoraproject.org/t/fedora-terminal-and-alternatives/106438
    ".local/bin/xdg-terminal-exec".source = dotfiles/managed/terminal/xdg-terminal-exec;

    ".local/share/dbus-1/services/ca.desrt.dconf-editor.service".source =
      dotfiles/managed/dbus-services/ca.desrt.dconf-editor.service;
    ".local/share/dbus-1/services/com.github.neithern.g4music.service".source =
      dotfiles/managed/dbus-services/com.github.neithern.g4music.service;
    ".local/share/dbus-1/services/io.gitlab.news_flash.NewsFlash.service".source =
      dotfiles/managed/dbus-services/io.gitlab.news_flash.NewsFlash.service;
    ".local/share/dbus-1/services/io.github.celluloid_player.Celluloid.service".source =
      dotfiles/managed/dbus-services/io.github.celluloid_player.Celluloid.service;
    ".local/share/dbus-1/services/org.gnome.seahorse.Application.service".source =
      dotfiles/managed/dbus-services/org.gnome.seahorse.Application.service;
  };

  # Makes writing dotfiles to ~/.config that little bit shorter
  xdg.configFile = {
    # "gtk-4.0/assets".source = "${pkgs.orchis-theme}/share/themes/Orchis-Light-Compact/gtk-4.0/assets";
    # "gtk-4.0/gtk.css".source = "${pkgs.orchis-theme}/share/themes/Orchis-Light-Compact/gtk-4.0/gtk.css";
    "autostart/login-sound.desktop".source = dotfiles/managed/autostart/login-sound.desktop;
    "docker/config.json".source = dotfiles/managed/terminal/docker-config.json;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
