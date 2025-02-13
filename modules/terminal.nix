{ config, pkgs, ... }:
{
  # Terminal
  programs.wezterm = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.wezterm);
    extraConfig = builtins.readFile ../dotfiles/wezterm.lua;
  };
  # System info
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "~/Pictures/luce-bankai.jpeg";
        type = "kitty";
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
          format = "Fedora Silverblue 41";
        }
        "host"
        "uptime"
        "packages"
        "de"
        "wm"
        "theme"
        "icons"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "localip"
        "break"
        "colors"
      ];
    };
  };

  # Shell customization 
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ../dotfiles/starship.toml;
  };
}
