{
  lib,
  config,
  pkgs,
  pkgs-stable,
  nixgl,
  ...
}:

{
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./modules/flatpak.nix
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

  nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    (with pkgs; [
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
      #     gnomeExtensions.auto-move-windows
      # Nice workflow stuff
      #      gnomeExtensions.rounded-window-corners-reborn
      # gtk-engine-murrine
      # sassc

      # Terminal tools
      (config.lib.nixGL.wrap wezterm)
      yt-dlp
      wgcf
      unimatrix
      fzf
      xorg.xlsclients
      p7zip

      # Dev tools
      jetbrains-toolbox
      gh
      mise
      gcc
      gdb
      cppcheck
      sqlite
      turso-cli
      (config.lib.nixGL.wrap warp-terminal)
      
      # Sec tools
      ghidra
      detect-it-easy
      zap

      # Container tools
      flatpak-builder
      appstream
      docker-compose
      kubectl
      kind
      nixd
      nixfmt-rfc-style
    ])
    ++ (with pkgs-stable; [
      # Packages that break with nightly
      vagrant
    ]);

  # Fish shell configuration
  programs.fish = {
    enable = true;
    shellAliases = {
      nix-update = "cd ${config.home.homeDirectory}/.config/nix-config && nix flake update && cd -";
      nix-upgrade = "home-manager switch"; # && nix-collect-garbage --delete-older-than 14d
      nix-edit = "code ${config.home.homeDirectory}/.config/nix-config";
    };
    shellInit = ''
      set fish_greeting # Disable greeting

      mise activate fish | source

      fish_add_path --global ~/.yarn/bin
    '';
  };

  # If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    # EDITOR = "emacs";
    DOCKER_CONFIG = "${config.home.homeDirectory}/.config/docker";
    NIXOS_OZONE_WL = "1";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock";
  };

  # # It is sometimes useful to fine-tune packages, for example, by applying
  # # overrides. You can do that directly here, just don't forget the
  # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
  # # fonts?
  # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

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
        "caffeine@patapon.info"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Marble-gnomeblue-dark";
    };
  };

  # My symlinks
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/blank' in
    # # the Nix store.
    ".local/share/icons/Numix".source = "${pkgs.numix-icon-theme-circle}/share/icons/Numix";
    ".local/share/icons/Numix-Light".source = "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Light";
    ".local/share/icons/Numix-Circle".source =
      "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Circle";
    ".local/share/icons/Numix-Circle-Light".source =
      "${pkgs.numix-icon-theme-circle}/share/icons/Numix-Circle-Light";

    # Sets default terminal for Gnome .desktop shortcuts
    # See: https://github.com/ublue-os/main/issues/211#issuecomment-1551600704
    # Also see: https://discussion.fedoraproject.org/t/fedora-terminal-and-alternatives/106438
    ".local/bin/xdg-terminal-exec".source = dotfiles/xdg-terminal-exec;

    ".local/share/dbus-1/services/ca.desrt.dconf-editor.service".source =
      dotfiles/dbus-services/ca.desrt.dconf-editor.service;
    ".local/share/dbus-1/services/com.github.neithern.g4music.service".source =
      dotfiles/dbus-services/com.github.neithern.g4music.service;
    ".local/share/dbus-1/services/com.github.wwmm.easyeffects.service".source =
      dotfiles/dbus-services/com.github.wwmm.easyeffects.service;
    ".local/share/dbus-1/services/io.github.celluloid_player.Celluloid.service".source =
      dotfiles/dbus-services/io.github.celluloid_player.Celluloid.service;
    ".local/share/dbus-1/services/org.gnome.seahorse.Application.service".source =
      dotfiles/dbus-services/org.gnome.seahorse.Application.service;
    ".local/share/dbus-1/services/re.sonny.Tangram.service".source =
      dotfiles/dbus-services/re.sonny.Tangram.service;
  };

  xdg.configFile = {
    # "gtk-4.0/assets".source = "${pkgs.orchis-theme}/share/themes/Orchis-Light-Compact/gtk-4.0/assets";
    # "gtk-4.0/gtk.css".source = "${pkgs.orchis-theme}/share/themes/Orchis-Light-Compact/gtk-4.0/gtk.css";
    "docker/config.json".source = dotfiles/docker-config.json;
    "wezterm/wezterm.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-config/dotfiles/wezterm.lua";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
