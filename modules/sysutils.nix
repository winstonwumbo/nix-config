{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    smartmontools
    ncdu
    rclone
    
    yt-dlp
    wgcf
    unimatrix
    # Check active x11 sessions
    xlsclients
    p7zip
    nvtopPackages.intel
  ];

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