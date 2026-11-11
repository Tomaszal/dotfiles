{
  inputs,
  config,
  lib,
  withSystem,
  ...
}: {
  options.nixos-release = lib.mkOption {
    default = "26.05";
  };

  config = {
    flake-file.inputs = {
      multiverse.url = "github:fzakaria/nixpkgs-multiverse";
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    perSystem = {system, ...}: {
      _module.args.mv = inputs.multiverse.lib.mkMultiverse {
        inherit system;
      };
    };

    den.schema.host = {host, ...}: {
      config = lib.mkIf (host.class == "nixos") {
        instantiate =
          withSystem host.system ({mv, ...}:
            (mv.flakeAt config.nixos-release).lib.nixosSystem);
      };
    };

    den.default.nixos = {
      config,
      pkgs,
      ...
    }: {
      _module.args.mv = inputs.multiverse.lib.mkMultiverse {
        inherit (config.nixpkgs) config overlays;
        inherit (pkgs.stdenv.hostPlatform) system;
      };
    };

    den.schema.hm-host.includes = [
      {
        nixos = {mv, ...}: {
          home-manager.extraSpecialArgs = {inherit mv;};
        };
      }
    ];
  };
}
