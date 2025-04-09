{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;

    profiles = {
      default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        extensions =
          (with pkgs.vscode-marketplace; [
            # list of stable extensions pulled straight from michaelsoft
            jnoortheen.nix-ide
            ms-vscode.cpptools-themes
            runem.lit-plugin
            bierner.lit-html
            ms-python.python
            ms-python.vscode-pylance
            ms-python.debugpy
            rdnlsmith.linux-themes
          ])
          ++ (with pkgs.vscode-extensions; [
            # list of extensions that need nixpkgs patches
            ms-vscode-remote.remote-ssh
            github.copilot
            github.copilot-chat
            ms-toolsai.jupyter
            ms-toolsai.jupyter-keymap
            ms-toolsai.jupyter-renderers
            ms-toolsai.vscode-jupyter-cell-tags
            ms-toolsai.vscode-jupyter-slideshow
          ]);
          
        userSettings = {
          # This property will be used to generate settings.json:
          "workbench.colorTheme" = "United GNOME";
          "editor.fontFamily" = "'JetBrainsMono Nerd Font Mono', 'Droid Sans Mono', 'monospace', monospace";
          "terminal.integrated.fontSize" = 15;
          "window.titleBarStyle" = "custom";

          # "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font Mono', 'monospace', monospace";
          "terminal.integrated.enableImages" = true;
          
        };
      };
    };
  };
}
