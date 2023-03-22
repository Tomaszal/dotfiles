# Tomaszal Dotfiles

## Installation

1. Run `nix build .#installer` in this flake to build the installer ISO.
2. Create a Ventoy USB stick if not already present using `just ventoy`.
3. Copy the installer ISO from `./result/iso/nixos-installer.iso` to the Ventoy USB stick.
4. Boot up the installer on target machine.
5. Use `lsblk` to see the available disks and `just` to see the installer commands.
