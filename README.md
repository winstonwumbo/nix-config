![image](https://github.com/user-attachments/assets/220637c2-87f5-44db-9548-7ea5b7afa0f8) 
## :)

## Getting Started
Install the Nix package manager on your distro with the Determinate installer.
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
Run `nix-setup.sh` to initialize home-manager using flakes.
```
chmod u+x nix-setup.sh
./nix-setup.sh
```