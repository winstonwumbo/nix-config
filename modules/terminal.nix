{ config, pkgs, ... }:
{
  # Shell customization
  home.packages = with pkgs; [
    (config.lib.nixGL.wrap wezterm)
    starship
    fzf
  ];

  xdg.configFile = {
    "wezterm/wezterm.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-config/dotfiles/managed/terminal/wezterm.lua";
    "starship.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-config/dotfiles/managed/terminal/starship.toml";
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      if [ -f /etc/bashrc ]; then
        . /etc/bashrc
      fi
      if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
        PATH="$HOME/.local/bin:$HOME/bin:$PATH"
      fi
      export PATH
    '';
  };

  # Fish shell configuration
  programs.fish = {
    enable = true;
    shellAliases = {
      nix-update = "cd ${config.home.homeDirectory}/.config/nix-config && nix flake update && cd -";
      nix-upgrade = "home-manager switch --flake ${config.home.homeDirectory}/.config/nix-config/";
      nix-edit = "code ${config.home.homeDirectory}/.config/nix-config";
      nix-autoclean = "nix-collect-garbage --delete-older-than 14d";
      nix-oc = "opencode -c ${config.home.homeDirectory}/.config/nix-config";
      frun = "flatpak run";
      fzf-p = "fzf --preview 'cat {}'";
      restart-xdg-filepicker = "systemctl --user restart xdg-desktop-portal.service";
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

  # programs.starship = {
  #   # autoenables the shell activation for nix-controlled shell
  #   # otherwise remember to copy: starship init fish | source
  #   enable = true;
  #   # Translate to native options at some point
  # };

  # System info
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "${config.home.homeDirectory}/Pictures/luce-bankai.jpeg";
        type = "sixel";
        padding = {
          right = 6;
        };
        width = 30;
        height = 18;
      };
      display = {
        color = "cyan";
      };
      modules = [
        "title"
        "break"
        {
          type = "os";
          format = "{name} {version-id} [{variant} {arch}]";
        }
        "host"
        "uptime"
        {
          type = "packages";
          format = "{rpm} (rpm), {nix-user} (nix-user), {flatpak-all} (flatpak)";
        }
        "de"
        "wm"
        {
          type = "theme";
          format = "Marble [Shell], Graphite Nord [GTK2/3/4]";
        }
        "icons"
        {
          type = "font";
          format = "Helvetica Standard (Liberation Sans...)";
        }
        {
          type = "terminal";
          format = "{pretty-name} ({version})";
        }
        "cpu"
        "memory"
        "disk"
        "localip"
        "break"
        "colors"
      ];
    };
  };
}
