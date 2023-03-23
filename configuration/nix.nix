{
  lib,
  config,
  ...
}: {
  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow configured unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) config.allowUnfreePackages;
}
