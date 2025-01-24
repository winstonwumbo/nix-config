{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    extensions =
      (with pkgs.vscode-marketplace; [
        # list of stable extensions pulled straight from michaelsoft
        jnoortheen.nix-ide
        ms-vscode.cpptools-themes
        runem.lit-plugin
        bierner.lit-html
        rdnlsmith.linux-themes
      ])
      ++ (with pkgs.vscode-extensions; [
        # list of extensions that need nixpkgs patches
        ms-vscode-remote.remote-ssh
        github.copilot
        github.copilot-chat
      ]);
    userSettings = {
      # This property will be used to generate settings.json:
      "workbench.colorTheme" = "United GNOME";
    };
  };
}