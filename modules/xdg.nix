{ pkgs, ... }:
{

  xdg.desktopEntries.code = {
    categories = [
      "Utility"
      "TextEditor"
      "Development"
      "IDE"
    ];
    comment = "Code Editing. Redefined.";
    exec = "code --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto %F";
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
        exec = "code --new-window --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto %F";
        icon = "vscode";
      };
    };
  };
}
