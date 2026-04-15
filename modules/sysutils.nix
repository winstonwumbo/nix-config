{ config, pkgs, ... }:
{
  # Module: system utilities
  home.packages = with pkgs; [
    smartmontools # disk health
    ncdu # disk usage
    rclone # cloud storage
    nvtopPackages.intel # gpu status
    xlsclients # Check active x11 sessions
    wgcf # cloudflare vpn profile
    p7zip # 7-zip

    yt-dlp # youtube downloader
    unimatrix # the matrix
  ];

  home.shellAliases = {
    restart-xdg-filepicker = "systemctl --user restart xdg-desktop-portal.service";
    ssmartctl = "sudo ${config.home.homeDirectory}/.nix-profile/bin/smartctl";
    sncdu = "sudo ${config.home.homeDirectory}/.nix-profile/bin/ncdu";
  };

  services.flatpak.packages = [
    "com.bitwarden.desktop"
    "com.github.tchx84.Flatseal"
    "ca.desrt.dconf-editor"
    "org.gnome.seahorse.Application"
    "io.github.flattool.Warehouse"
    "com.github.wwmm.easyeffects"
    "dev.serebit.Waycheck"
    "io.missioncenter.MissionCenter"
    "net.nokyan.Resources"
  ];

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

  # System status
  programs.bottom = {
    enable = true;
    settings = {
      row = [
        {
          child = [
            { type = "cpu"; }
          ];
        }
        {
          ratio = 2;
          child = [
            {
              ratio = 2;
              child = [
                { type = "mem"; }
                { type = "net"; }
              ];
            }
            {
              ratio = 4;
              type = "proc";
              default = true;
            }
          ];
        }
      ];
    };
  };

  # bottom doesn't have a desktop icon but ships with a .desktop shortcut
  xdg.desktopEntries.bottom = {
    categories = [
      "System"
      "ConsoleOnly"
      "Monitor"
    ];
    comment = "A customizable cross-platform graphical process/system monitor for the terminal.";
    exec = "btm";
    genericName = "System Monitor";
    icon = "bashtop";
    name = "bottom";
    settings = {
      Version = "1.5";
    };
    terminal = true;
    type = "Application";
    startupNotify = false;
  };

  xdg.desktopEntries.top-monitor = {
    categories = [
      "System"
      "ConsoleOnly"
      "Monitor"
    ];
    comment = "My cool Wezterm shortcut";
    icon = "htop";
    name = "topmon";
    genericName = "Top Monitor";
    exec = "wezterm start --always-new-process -- --task-manager";
    type = "Application";
    terminal = false;
    startupNotify = false;
  };
}
