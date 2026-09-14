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
      multiverse.url = "github:fzakaria/nixpkgs-multiverse";
      nixpkgs.url = "github:nixos/nixpkgs/nixos-${config.nixos-release}";
    };

    perSystem = {system, ...}: {
      _module.args.pkgs-mv = inputs.multiverse.lib.mkMultiverse {
        inherit system;
      };
    };

    den.default.nixos = {
      config,
      pkgs,
      ...
    }: {
      _module.args.pkgs-mv = inputs.multiverse.lib.mkMultiverse {
        inherit (config.nixpkgs) config overlays;
        inherit (pkgs.stdenv.hostPlatform) system;
      };
    };

    den.schema.hm-host.includes = [
      {
        nixos = {pkgs-mv, ...}: {
          home-manager.extraSpecialArgs = {inherit pkgs-mv;};
        };
      }
    ];
  };
}
