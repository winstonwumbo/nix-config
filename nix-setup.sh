#!/bin/bash

# Makes / temporarily writable (for stuff like Nix installer)
# https://github.com/coreos/rpm-ostree/issues/337#issuecomment-2856321727
# https://github.com/DeterminateSystems/nix-installer/issues/1445#issuecomment-2856334377
if [ -f /run/ostree-booted ]; then
  if [ ! -f /etc/ostree/prepare-root.conf ]; then
    sudo tee /etc/ostree/prepare-root.conf <<'EOL'
[composefs]
enabled = yes
[root]
transient = true
EOL

    rpm-ostree initramfs-etc --reboot --track=/etc/ostree/prepare-root.conf
    printf "Enabled \033[34mtransient root\033[0m to support the \033[34mNix Store\033[0m on \033[34mOSTree\033[0m\n"
    printf "Please \033[34mrestart\033[0m your device, then rerun \033[34mnix-setup.sh\033[0m\n"
    return
  fi
fi

# Initialize home-manager flake
nix run home-manager/master -- init --switch

# Move to correct directory
cd "$HOME"/.config || return

# Remove home-manager presets
rm -r home-manager/

home-manager switch --flake "$HOME"/.config/nix-config/