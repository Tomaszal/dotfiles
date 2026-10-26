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

Bootstrap each new clone or worktree to generate repository agent configuration and Moon schemas:

```sh
moon run repo:bootstrap
```

## Working in the repository

Use these Moon tasks for common development work:

| Command | Purpose |
| --- | --- |
| `moon run repo:nixos/build` | Build the current host configuration without activating it. |
| `moon run repo:nixos/switch` | Build and activate the current host configuration. |
| `moon run repo:update` | Update repository dependencies. |
| `moon run repo:check` | Run repository checks. |
| `moon run repo:fix` | Apply repository formatters and automatic fixes. |

Find other tasks with `moon tasks`, inspect a task with `moon task <task>`, and run it with `moon run <task>`.

Machine names match hostnames and `nixosConfigurations` names. Build and switch tasks default to the current host. To select another host:

```sh
moon run repo:nixos/build -- --hostname laptop
```

## Installation

Build the installer ISO:

```sh
moon run repo:nixos/installer
```

Boot the target machine from `./result/iso/nixos-installer.iso`, inspect disks with `lsblk`, then install:

```sh
disko-install --flake .#<host> --disk nixos /dev/disk-path
```

Replace `<host>` with the target hostname and `/dev/disk-path` with the target disk. Confirm the disk path and layout before installing.

## Layout

| Location                                                          | Purpose                                                                                                                                                                                            |
| ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [flake.nix](flake.nix)                                            | Generated from module settings; do not edit directly. After changing `flake-file.*` inputs or parameters, regenerate with `moon run repo:flake/generate`. Build tasks regenerate it automatically. |
| [modules/](modules/)                                              | Shared features, grouped by area such as `system`, `programs`, and `dev`.                                                                                                                          |
| [modules/flake/](modules/flake/) and [modules/nix/](modules/nix/) | Flake inputs and settings, the development shell, and Nix configuration.                                                                                                                           |
| [modules/hosts/](modules/hosts/)                                  | Host composition, disk layouts, and hardware facts, grouped by hostname.                                                                                                                           |
| [modules/users/](modules/users/)                                  | User configuration, grouped by username.                                                                                                                                                           |
| [moon.yaml](moon.yaml) and [.moon/](.moon/)                       | Development tasks and Moon workspace configuration.                                                                                                                                                |
| [.apm/](.apm/) and [apm.yml](apm.yml)                             | Repository agent instructions and conventions, compilation targets, and dependencies. Apply changes with `moon run repo:agents/sync`.                                                              |
