{ config, pkgs, ... }:
{
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
            runem.lit-plugin
            bierner.lit-html
            ms-python.python
            ms-python.vscode-pylance
            ms-python.debugpy
            julialang.language-julia

            smockle.xcode-default-theme
            pkief.material-icon-theme
          ])
          ++ (with pkgs.vscode-extensions; [
            # list of extensions that need nixpkgs patches
            # Seems to break less if I just install them from VSCode imperatively
            ms-vscode.remote-explorer
            ms-vscode-remote.remote-ssh
            ms-azuretools.vscode-containers
            github.copilot
            github.copilot-chat
            # ms-toolsai.jupyter
            # ms-toolsai.jupyter-keymap
            # ms-toolsai.jupyter-renderers
            # ms-toolsai.vscode-jupyter-cell-tags
            # ms-toolsai.vscode-jupyter-slideshow
          ]);

        userSettings = {
          # This property will be used to generate settings.json:
          "workbench.colorTheme" = "Xcode Partial (Dark)";
          "workbench.iconTheme" = "material-icon-theme";
          "editor.fontFamily" = "'JetBrainsMono Nerd Font Mono', 'Droid Sans Mono', 'monospace', monospace";
          "terminal.integrated.fontSize" = 15;
          "window.titleBarStyle" = "custom";
          "workbench.sideBar.location" = "left";

          # "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font Mono', 'monospace', monospace";
          "terminal.integrated.enableImages" = true;

          # Language configs
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
            };
          };
          # "nix.serverSettings" = {
          #   "nixd" = {
          #     "nixpkgs" = {
          #       "expr" = "import (builtins.getFlake (builtins.toString ${config.home.homeDirectory}/.config/nix-config)).inputs.nixpkgs { }   ";
          #     };
          #     "formatting" = {
          #       "command" = [ "nixfmt" ];
          #     };
          #     "options" = {
          #       "home-manager" = {
          #         "expr" = "(builtins.getFlake (builtins.toString ${config.home.homeDirectory}/.config/nix-config)).homeConfigurations.ruyu.options";
          #       };
          #     };
          #   };
          # };

          "julia.executablePath" =
            "${config.home.homeDirectory}/.local/share/mise/installs/julia/latest/bin/julia";
          "julia.enableTelemetry" = false;
          "julia.enableCrashReporter" = false;
          "julia.symbolCacheDownload" = true;
          "terminal.integrated.commandsToSkipShell" = [
            "language-julia.interrupt"
          ];

          # AI preferences
          "editor.inlineSuggest.enabled" = false;
          "github.copilot.enable" = {
            "*" = false;
          };
          "github.copilot.editor.enableCodeActions" = false;
          "github.copilot.nextEditSuggestions.enabled" = false;
          "github.copilot.nextEditSuggestions.fixes" = false;
          "github.copilot.renameSuggestions.triggerAutomatically" = false;
          "chat.agent.enabled" = false;
          "chat.edits2.enabled" = false;
          "chat.mcp.enabled" = false;
          "chat.mcp.discovery.enabled" = false;
          "inlineChat.holdToSpeech" = false;
          "workbench.settings.showAISearchToggle" = false;
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
