{ config, pkgs, ... }:
{
  # Shell customization
  home.packages = with pkgs; [
    (config.lib.nixGL.wrap wezterm)
    htop
    smartmontools
    rclone
    ncdu
    yt-dlp
    wgcf
    unimatrix
    fzf
    xlsclients
    p7zip
  ];

  programs.starship = {
    # autoenables the shell activation for nix-controlled shell
    # otherwise remember to copy: starship init fish | source
    enable = true;
    # Translate to native options at some point
  };

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

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        theme = {
          enable = true;
          name = "tokyonight";
          style = "moon";
        };

        dashboard.alpha = {
          enable = true;
          theme = "dashboard";
          # opts = {
          #   section.header.val = [
          #       "                                                     "
          #       "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ "
          #       "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ "
          #       "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ "
          #       "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ "
          #       "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ "
          #       "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ "
          #       "                                                     "
          #   ];
          # };
        };

        mini = {
          files.enable = true;
          completion.enable = true;
          snippets.enable = true;
        };

        statusline.lualine = {
          enable = true;
        };

        options.tabstop = 4;

        lsp.enable = true;
        languages = {
          enableTreesitter = true;

          nix.enable = true;
        };
      };
    };
  };

  programs.opencode = {
    enable = true;
    settings = {
      theme = "system";
      share = "disabled";
      default_agent = "plan";
    };
  };
}
