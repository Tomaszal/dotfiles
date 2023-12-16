{
  lib,
  config,
  ...
}: {
  nix.settings = {
    # Enable flakes
    experimental-features = ["nix-command" "flakes"];

    # Enable Hyprland Cachix
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Allow configured unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) config.allowUnfreePackages;
}
