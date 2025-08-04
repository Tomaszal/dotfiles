{
  self,
  config,
  pkgs,
  ...
}: {
  services.flatpak.enable = true;

  hm.services.flatpak.packages = ["com.github.tchx84.Flatseal"];

  # Home manager module
  # https://github.com/gmodena/nix-flatpak
  hm.imports = [self.inputs.nix-flatpak.homeManagerModules.nix-flatpak];

  # GUI for basic Flatpak application management
  environment.systemPackages = [pkgs.gnome-software];

  # Fix missing fonts and cursors
  # https://wiki.nixos.org/wiki/Flatpak#Missing_themes_and_cursors
  # https://wiki.nixos.org/wiki/Fonts#Solution_3:_Configure_bindfs_for_fonts/cursors/icons_support
  system.fsPackages = [pkgs.bindfs];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
    };
    aggregated = pkgs.buildEnv {
      name = "system-fonts-and-icons";
      paths = config.fonts.packages ++ [config.hm.home.pointerCursor.package];
      pathsToLink = ["/share/fonts" "/share/icons"];
    };
  in {
    "/usr/share/fonts" = mkRoSymBind "${aggregated}/share/fonts";
    "/usr/share/icons" = mkRoSymBind "${aggregated}/share/icons";
  };
}
