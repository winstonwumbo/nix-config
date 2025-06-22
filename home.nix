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
    # ./modules/gtk.nix
#    ./modules/helix.nix
    ./modules/browsers.nix
    ./modules/terminal.nix
    ./modules/vscode.nix
    ./modules/xdg.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ruyu";
  home.homeDirectory = "/var/home/ruyu";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
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
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello

      # Gnome config
      (pkgs.marble-shell-theme.override {
        colors = [ "blue" ];
        additionalInstallationTweaks = [ "-Pnp" "--hue=220" "--name=gnomeblue" "--mode=dark" "--filled" "-O" "--sat=80"];
      })

      nerd-fonts.jetbrains-mono
      gnome-tweaks
      
      # Desktop extensions
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

      # CLI utils
      yt-dlp
      wgcf
      unimatrix
      fzf
      xorg.xlsclients
      p7zip
      ffmpeg

      # Dev tools
      mise
      gcc
      gdb
      turso-cli
      sqlite
      jetbrains.pycharm-community
      jetbrains.clion

      # Cyber tools
      nmap
      ghidra

      flatpak-builder
      appstream

      nixfmt-rfc-style
    ])
    ++ (with pkgs-stable; [
      # Packages that break with nightly

      # CLI
      vagrant
    ]);
  
  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "arcmenu@arcmenu.com"
        "dash-to-panel@jderose9.github.com"
        "caffeine@patapon.info"
      ];
    };

    "org/gnome/shell/extensions/user-theme" = {
        name = "Marble-gnomeblue-dark";
    };
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ruyu/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    NIXOS_OZONE_WL = "1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
