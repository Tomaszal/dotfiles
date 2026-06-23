{
  inputs,
  config,
  lib,
  ...
}: {
  options.nixos-release = lib.mkOption {
    default = "26.05";
  };

  config = {
    flake-file.inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-${config.nixos-release}";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    den.default = {
      nixos = {pkgs, ...}: {
        _module.args.pkgs-unstable = import inputs.nixpkgs-unstable pkgs;
      };

      homeManager = {pkgs, ...}: {
        _module.args.pkgs-unstable = import inputs.nixpkgs-unstable pkgs;
      };
    };
  };
}
