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
    ./modules/helix.nix
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
  home.stateVersion = "24.11"; # Please read the comment before changing.

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

      # Config
      nerd-fonts.jetbrains-mono
      nerd-fonts._3270
      nerd-fonts.sauce-code-pro
      nerd-fonts.roboto-mono
      nerd-fonts.ubuntu-sans
      nerd-fonts.mononoki
      nerd-fonts.iosevka
      nerd-fonts.blex-mono
      nerd-fonts.caskaydia-cove
      nerd-fonts._0xproto

      p7zip

      ffmpeg

      # Utilities
      yt-dlp
      wgcf
      bitwarden-desktop

      gnome-tweaks
      # Popular
      gnomeExtensions.dash-to-panel
      gnomeExtensions.arcmenu
      # Maintained by Ubuntu
      gnomeExtensions.appindicator
      # Maintained by Gnome
      gnomeExtensions.auto-move-windows
      gnomeExtensions.user-themes
      # Nice workflow stuff
      gnomeExtensions.rounded-window-corners-reborn
      gtk-engine-murrine
      sassc

      # CLI
      nmap
      unimatrix
      fzf
      xorg.xlsclients

      # Dev Tools
      mise
      gcc
      gdb
      turso-cli
      sqlite

      jetbrains.pycharm-community
      jetbrains.clion
      ghidra

      flatpak-builder
      appstream

      nixpkgs-manual
      nixfmt-rfc-style
    ])
    ++ (with pkgs-stable; [
      # Packages that break with nightly

      # CLI
      vagrant
    ]);

    programs.zsh.enable = true;

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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
