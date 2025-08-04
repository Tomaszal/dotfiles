{
  config,
  lib,
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

  config.nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) config.allowUnfreePackages;
}
