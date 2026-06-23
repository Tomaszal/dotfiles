{inputs, ...}: {
  flake-file.inputs.nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

  den.default = {
    nixos = {
      pkgs,
      config,
      ...
    }: {
      services.flatpak.enable = true;

      # Fix missing cursors
      # https://wiki.nixos.org/wiki/Flatpak#Missing_themes_and_cursors
      # https://wiki.nixos.org/wiki/Fonts#Solution_3:_Configure_bindfs_for_fonts/cursors/icons_support
      system.fsPackages = with pkgs; [bindfs];
      fileSystems = let
        mkRoSymBind = path: {
          device = path;
          fsType = "fuse.bindfs";
          options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
        };
        aggregated = pkgs.buildEnv {
          name = "system-icons";
          paths = [config.pointerCursorPackage];
          pathsToLink = ["/share/fonts" "/share/icons"];
        };
      in {
        "/usr/share/fonts" = mkRoSymBind "${aggregated}/share/fonts";
        "/usr/share/icons" = mkRoSymBind "${aggregated}/share/icons";
      };
    };

    homeManager = {pkgs, ...}: {
      imports = [inputs.nix-flatpak.homeManagerModules.nix-flatpak];

      # GUI for basic Flatpak application management
      home.packages = with pkgs; [gnome-software];

      services.flatpak.packages = ["com.github.tchx84.Flatseal"];
    };
  };
}
