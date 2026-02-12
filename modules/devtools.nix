{
  config,
  pkgs,
  pkgs-stable,
  ...
}:
{
  home.packages =
    (with pkgs; [
      # programming
      jetbrains-toolbox
      gh
      mise
      yarn
      gcc
      gdb
      cppcheck
      sqlite
      turso-cli

      # infra
      terraform
      terraform-ls

      # containers
      flatpak-builder
      appstream
      docker-compose
      kubectl
      kind

      # security
      nmap
      zap
      (config.lib.nixGL.wrap burpsuite)
      ghidra
      detect-it-easy

      # nix
      nixd
      nil
      nixfmt
    ])
    ++ (with pkgs-stable; [
      # Packages that break with nightly
      vagrant
    ]);

  programs.opencode = {
    enable = true;
    settings = {
      theme = "system";
      share = "disabled";
      default_agent = "plan";
    };
  };
}
