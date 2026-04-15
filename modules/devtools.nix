{
  config,
  pkgs,
  pkgs-stable,
  ...
}:
{
  # Module: development tools
  home.packages =
    (with pkgs; [
      # programming
      jetbrains.clion
      jetbrains.datagrip
      gh
      mise
      yarn
      gcc
      gdb
      cppcheck
      sqlite
      turso-cli

      shellcheck

      # infra
      terraform
      terraform-ls
      awscli2
      azure-cli
      google-cloud-sdk
      oci-cli

      # containers
      flatpak-builder
      appstream
      docker-compose
      ddev
      kubectl
      kind

      # nix
      nixd
      nil
      nixfmt
    ])
    ++ (with pkgs-stable; [
      # Packages that break with nightly
      vagrant
    ]);

  xdg.configFile = {
    "docker/config.json".source = ../dotfiles/managed/terminal/docker-config.json;
  };
  
  home.sessionVariables = {
    DOCKER_CONFIG = "${config.home.homeDirectory}/.config/docker";
  };

  services.flatpak.packages = [
    "org.virt_manager.virt-manager" # Manually select QEMU/System session after install
    "io.podman_desktop.PodmanDesktop"
  ];
}
