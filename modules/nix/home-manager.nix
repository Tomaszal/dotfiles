{config, ...}: {
  flake-file.inputs.home-manager = {
    url = "github:nix-community/home-manager/release-${config.nixos-release}";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # TODO(NixOS 26.11): Remove this input once both harnesses use release-26.11
  # modules, then regenerate flake.nix and prune its lock entry.
  flake-file.inputs.home-manager-unstable = {
    url = "github:nix-community/home-manager/master";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.schema.user.classes = ["homeManager"];

  # Host-scoped Home Manager settings must go through `hm-host`, which is only
  # applied to hosts that actually have Home Manager users.
  den.schema.hm-host.includes = [
    {
      nixos.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }
  ];
}
