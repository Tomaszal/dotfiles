{
  lib,
  config,
  ...
}: {
  options = let
    inherit (lib) mkOption types;
    inherit (types) str listOf;
  in {
    allowUnfreePackages = mkOption {
      type = listOf str;
      default = [];
    };
  };

  config = {
      # Enable flakes
    nix.settings. experimental-features = ["nix-command" "flakes"];

    # Allow configured unfree packages
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) config.allowUnfreePackages;
  };
}
