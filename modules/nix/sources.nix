# nvfetcher sources exposed as a module arg so consumers do not need a relative
# path to the generated file.
{
  perSystem = {pkgs, ...}: {
    _module.args.sources = pkgs.callPackage ../../_sources/generated.nix {};
  };

  den.default.nixos = {pkgs, ...}: {
    _module.args.sources = pkgs.callPackage ../../_sources/generated.nix {};
  };
}
