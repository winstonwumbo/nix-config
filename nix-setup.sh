#!/bin/bash

# Initialize home-manager flake
nix run home-manager/master -- init --switch

# Move to correct directory
cd ~/.config

# Remove home-manager presets
rm -r home-manager/*

# Make symlinks
ln -s -r nix-config/home.nix home-manager/home.nix
ln -s -r nix-config/flake.nix home-manager/flake.nix
