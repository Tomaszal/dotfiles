{
  inputs,
  config,
  lib,
  ...
}: let
  mkPkgs = nixpkgs: {
    localSystem,
    crossSystem ? localSystem,
    config ? {},
    overlays ? [],
  }:
    import nixpkgs (
      {inherit config localSystem overlays;}
      // lib.optionalAttrs (localSystem != crossSystem) {inherit crossSystem;}
    );
in {
  options.nixos-release = lib.mkOption {
    default = "26.05";
  };

  config = {
    flake-file.inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-${config.nixos-release}";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    perSystem = {system, ...}: let
      nixpkgsArgs = {localSystem.system = system;};
    in {
      _module.args = {
        pkgs = mkPkgs inputs.nixpkgs nixpkgsArgs;
        pkgs-unstable = mkPkgs inputs.nixpkgs-unstable nixpkgsArgs;
      };
    };

    den.default.nixos = {
      config,
      pkgs,
      ...
    }: {
      _module.args.pkgs-unstable = mkPkgs inputs.nixpkgs-unstable {
        localSystem.config = pkgs.stdenv.buildPlatform.config;
        crossSystem.config = pkgs.stdenv.hostPlatform.config;
        inherit (config.nixpkgs) config overlays;
      };
    };
  };
}
