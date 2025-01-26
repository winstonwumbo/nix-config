{ pkgs, ... }:
{
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
        "os"
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
    settings = {
      username.show_always = true;
    };
  };
}
