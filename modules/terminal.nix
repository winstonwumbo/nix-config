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

  # Shell customization 
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ../dotfiles/starship.toml;
  };
}
