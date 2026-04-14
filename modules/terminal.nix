{ config, pkgs, ... }:
{
  # Terminal experience
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

  # Bash (login/scripting shell)
  programs.bash = {
    enable = true;
    profileExtra = ''
    # Determinate Nix + HM duplicates a lot of values
    export PATH=$(echo "$PATH" | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's/:$//')
    export XDG_DATA_DIRS=$(echo "$XDG_DATA_DIRS" | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's/:$//')
    '';
    bashrcExtra = ''
      if [ -f /etc/bashrc ]; then
        . /etc/bashrc
      fi
      if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
        PATH="$HOME/.local/bin:$HOME/bin:$PATH"
      fi
      export PATH

      eval "$(starship init bash)"
      eval "$(mise activate bash)"

      # home.sessionVars gets overwritten for common stuff like SSH_AUTH_SOCK
      export SSH_AUTH_SOCK=${config.home.homeDirectory}/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock
    '';
  };

  # Fish (interactive shell)
  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting # Disable greeting

      starship init fish | source
      mise activate fish | source

      # home.sessionVars gets overwritten for common stuff like SSH_AUTH_SOCK
      set -gx SSH_AUTH_SOCK '${config.home.homeDirectory}/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock'
      fish_add_path --global ${config.home.homeDirectory}/.yarn/bin
    '';
  };

  home.shellAliases = {
    nix-update = "cd ${config.home.homeDirectory}/.config/nix-config && nix flake update && cd -";
    nix-upgrade = "home-manager switch --flake ${config.home.homeDirectory}/.config/nix-config/";
    nix-edit = "code ${config.home.homeDirectory}/.config/nix-config";
    nix-autoclean = "nix-collect-garbage --delete-older-than 14d";
    nix-oc = "opencode -c ${config.home.homeDirectory}/.config/nix-config";
    fzf-p = "fzf --preview 'cat {}'";
    frun = "flatpak run";
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
    NIXOS_OZONE_WL = "1";
  };

  programs.opencode = {
    enable = true;
    settings = {
      share = "disabled";
      default_agent = "plan";
    };
    tui = {
      theme = "system";
    };
  };
}
