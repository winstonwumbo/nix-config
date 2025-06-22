{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    # mutableExtensionsDir = false;

    profiles = {
      default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        extensions =
          (with pkgs.vscode-marketplace; [
            # list of stable extensions pulled straight from michaelsoft
            jnoortheen.nix-ide
            # ms-vscode.cpptools-themes
            runem.lit-plugin
            bierner.lit-html
            ms-python.python
            ms-python.vscode-pylance
            ms-python.debugpy
            rdnlsmith.linux-themes
          ])
          ++ (with pkgs.vscode-extensions; [
            # list of extensions that need nixpkgs patches
            # Seems to break less if I just install them from VSCode imperatively
            # ms-vscode-remote.remote-ssh
            # github.copilot
            # github.copilot-chat
            # ms-toolsai.jupyter
            # ms-toolsai.jupyter-keymap
            # ms-toolsai.jupyter-renderers
            # ms-toolsai.vscode-jupyter-cell-tags
            # ms-toolsai.vscode-jupyter-slideshow
          ]);
          
        userSettings = {
          # This property will be used to generate settings.json:
          "workbench.colorTheme" = "United GNOME";
          "editor.fontFamily" = "'JetBrainsMono Nerd Font Mono', 'Droid Sans Mono', 'monospace', monospace";
          "terminal.integrated.fontSize" = 15;
          "window.titleBarStyle" = "custom";
          "workbench.sideBar.location" = "left";

          # "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font Mono', 'monospace', monospace";
          "terminal.integrated.enableImages" = true;
          
        };
      };
    };
  };

  # Desktop shortcuts
  xdg.desktopEntries.code = {
    categories = [
      "Utility"
      "TextEditor"
      "Development"
      "IDE"
    ];
    comment = "Code Editing. Redefined.";
    exec = "code --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %F";
    genericName = "Text Editor";
    icon = "vscode";
    name = "Visual Studio Code";
    startupNotify = true;
    settings = {
      Keywords = "vscode";
      StartupWMClass = "Code";
      Version = "1.4";
    };
    type = "Application";

    actions = {
      "new-empty-window" = {
        name = "New Empty Window";
        exec = "code --new-window --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland %F";
        icon = "vscode";
      };
    };
  };
}
