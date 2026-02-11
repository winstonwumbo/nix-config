{ config, pkgs, pkgs-stable, ... }:
{
  home.packages = (with pkgs; [
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

    # containers
    flatpak-builder
    appstream
    docker-compose
    kubectl
    kind

    # security
    ghidra
    nmap
    detect-it-easy
    zap
    (config.lib.nixGL.wrap burpsuite)

    # nix
    nixd
    nil
    nixfmt
  ]) 
  ++ (with pkgs-stable; [
    # Packages that break with nightly
    vagrant
  ]);
}