# Tomaszal Dotfiles

My personal NixOS dotfiles, using the [Den framework](https://den.denful.dev/).

## Prerequisites

Enter the development shell before running repository commands:

```sh
nix develop
```

Alternatively, load it automatically with:

```sh
direnv allow
```

## Working in the repository

Use Moon to discover commands, inspect their details, and run them:

```sh
moon tasks
moon task <task>
moon run <task>
```

Build and switch tasks default to the current host. To select another host:

```sh
moon run repo:nixos/build -- --hostname laptop
```

## Installation

Build the installer ISO:

```sh
moon run repo:nixos/installer
```

Boot the target machine from `./result/iso/nixos-installer.iso`, inspect disks
with `lsblk`, then install:

```sh
disko-install --flake .#<host> --disk nixos /dev/disk-path
```

Replace `<host>` with the target hostname and `/dev/disk-path` with the target disk.
Confirm the disk path and layout before installing.

## Layout

- `flake.nix`: generated from module settings; do not edit directly.
- `flake.lock`: pinned input revisions.
- `modules/flake/`: flake settings.
- `modules/hosts/<hostname>/`: host configuration and disk layouts.
- `modules/users/`: user configuration.
- `modules/nix/`: Nix and Home Manager settings.
- `modules/system/`: shared system configuration.
- `modules/dev/`, `modules/programs/`, `modules/games/`: tools and applications.
