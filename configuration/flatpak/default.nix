{
  self,
  config,
  pkgs,
  ...
}: {
  services.flatpak.enable = true;

  imports = [
    ./packages.nix
  ];

  # Home manager module
  # https://github.com/gmodena/nix-flatpak
  hm.imports = [self.inputs.nix-flatpak.homeManagerModules.nix-flatpak];

  # GUI for basic Flatpak application management
  environment.systemPackages = [pkgs.gnome.gnome-software];

  # Fix fonts and icons in Flatpak apps, remove when merged upstream
  # https://github.com/NixOS/nixpkgs/pull/262462
  fonts.fontDir.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      flatpak = prev.flatpak.overrideAttrs (o: {
        patches =
          (o.patches or [])
          ++ [
            # Try mounting fonts and icons from NixOS locations if FHS locations don't exist.
            # https://github.com/NixOS/nixpkgs/issues/119433
            ./fix-font-icons.patch
          ];
      });
    })
  ];

  # Fix cursors in some Flatpak apps (above fix is not enough)
  # https://github.com/NixOS/nixpkgs/issues/119433#issuecomment-1767513263
  system.fsPackages = [pkgs.bindfs];
  fileSystems = let
    aggregatedIcons = pkgs.buildEnv {
      name = "system-icons";
      paths = [config.hm.home.pointerCursor.package];
      pathsToLink = ["/share/icons"];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = {
      device = aggregatedIcons + "/share/icons";
      fsType = "fuse.bindfs";
      options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
    };
  };
}
