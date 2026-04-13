# nix-config :)

Welcome to my personal repo for all things **Nix**! Stay tuned for dotfiles, flakes, and other such Linuxing!

Some of the configurations may seem a little strange to long-term **NixOS** users. I'm a bit of a unique case. Most of my day-to-day is on immutable Linux distros, primarily Fedora Atomic. The **Nix** package manager has proven to be an awesome, flexible alternative to OSTree layers and Flatpaks. The **Home Manager (HM)** module powers my entire development setup, while keeping a tidy *Filesystem Hierarchy* for certain tools!

## Getting Started

### Prerequisites
* Git
* Bash (doesn't need to be your default shell)
* curl

### Install
Try out my personalized **Home Manager** deployments using this `nix-setup.sh` convenience script:
```bash
curl -fsSL https://raw.githubusercontent.com/winstonwumbo/nix-config/main/nix-setup.sh | bash
```
If you'd rather not `curl` an online script, clone the repository and run it by hand:
```bash
git clone https://github.com/winstonwumbo/nix-config.git
chmod u+x nix-setup.sh
./nix-setup.sh
```

`nix-setup.sh` compiles all the manual steps that I'd usually work through.

## Layout
```
├── dotfiles
│   ├── managed   # Non-Nix configs that are directly symlinked
│   └── unmanaged # Non-Nix configs that are manually applied to apps
├── flake.lock
├── flake.nix
├── home.nix      # Main hub for HM configs, mostly used for desktop (DE) tweaks here
├── icons         # Pictures of cool things
├── modules       # Nix modules for my apps, split based on common use-cases
├── nix-setup.sh  # Convenience script to quickly install Nix and dependencies, then clean up
└── README.md
```