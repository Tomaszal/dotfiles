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

    # Upstream cache: https://github.com/fzakaria/nixpkgs-multiverse/blob/main/.github/workflows/ci.yml
    # Signing key: https://app.cachix.org/api/v1/cache/nixpkgs-multiverse
    flake-file.nixConfig = {
      extra-substituters = ["https://nixpkgs-multiverse.cachix.org"];
      extra-trusted-public-keys = ["nixpkgs-multiverse.cachix.org-1:SqXTpRT4uZ+JP1NNVFqvsG3BkLAtPqPkFTuLfJHiqeQ="];
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
