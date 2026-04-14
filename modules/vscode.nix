{ config, pkgs, ... }:
let
  baseVSCodeSettings = {
    # ui
    "workbench.colorTheme" = "Xcode Partial (Dark)";
    "workbench.iconTheme" = "material-icon-theme";
    "editor.fontFamily" = "'JetBrainsMono Nerd Font Mono', 'Droid Sans Mono', 'monospace', monospace";
    "terminal.integrated.fontSize" = 15;
    "window.titleBarStyle" = "custom";
    "workbench.activityBar.location" = "top";
    "workbench.navigationControl.enabled" = false;
    # https://github.com/microsoft/vscode/issues/306156
    "chat.agentsControl.enabled" = "hidden";

    # tooling
    "git.autofetch" = true;
    "terminal.integrated.defaultProfile.linux" = "fish";
    "terminal.integrated.enableImages" = true;

    # ai
    "chat.disableAIFeatures" = true;
    "inlineChat.holdToSpeech" = false;
    "workbench.settings.showAISearchToggle" = false;
  };

  baseVSCodeExtensions = (with pkgs.vscode-marketplace; [
    # list of stable extensions pulled straight from michaelsoft
    timonwong.shellcheck

    # infra
    ms-vscode.remote-explorer
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-containers
    ms-azuretools.vscode-containers
    github.vscode-github-actions

    # theme
    smockle.xcode-default-theme
    pkief.material-icon-theme
  ]);
in
{
  programs.vscode = {
    enable = true;

    profiles = {
      default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        extensions = baseVSCodeExtensions ++
          (with pkgs.vscode-marketplace; [
            # list of stable extensions pulled straight from michaelsoft
            jnoortheen.nix-ide
            runem.lit-plugin
            bierner.lit-html
          ]);

        userSettings = baseVSCodeSettings // {
          # This property will be used to generate settings.json:
          # "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font Mono', 'monospace', monospace";

          # Language configs
          "nix.enableLanguageServer" = true;

          "nix.serverPath" = "nil";
          # "nix.serverSettings" = {
          #   "nixd" = {
          #     "nixpkgs" = {
          #       "expr" = "import (builtins.getFlake \"/var/home/ruyu/.config/nix-config\").inputs.nixpkgs { }";
          #     };
          #     "formatting" = {
          #       "command" = [ "nixfmt" ];
          #     };
          #     "options" = {
          #       "home-manager" = {
          #         "expr" = "(builtins.getFlake \"/var/home/ruyu/.config/nix-config\").homeConfigurations.ruyu.options";
          #       };
          #     };
          #   };
          # };
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
            };
          };
        };
      };
      Computational = {
        extensions = baseVSCodeExtensions ++
          (with pkgs.vscode-marketplace; [
            # list of stable extensions pulled straight from michaelsoft
            ms-python.python
            ms-python.vscode-pylance
            ms-python.debugpy
          ])
          ++ (with pkgs.vscode-extensions; [
            # list of extensions that need nixpkgs patches
            julialang.language-julia

            google.colab
            ms-toolsai.jupyter
            ms-toolsai.jupyter-keymap
            ms-toolsai.jupyter-renderers
            ms-toolsai.vscode-jupyter-cell-tags
            ms-toolsai.vscode-jupyter-slideshow
          ]);
        
        userSettings = baseVSCodeSettings // {
          "julia.executablePath" =
            "${config.home.homeDirectory}/.local/share/mise/installs/julia/latest/bin/julia";
          "julia.enableTelemetry" = false;
          "julia.enableCrashReporter" = false;
          "julia.symbolCacheDownload" = true;
          "terminal.integrated.commandsToSkipShell" = [
            "language-julia.interrupt"
          ];
        };
      };
    };
  };
}
