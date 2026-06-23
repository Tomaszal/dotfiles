{config, ...}: {
  flake-file.inputs.home-manager = {
    url = "github:nix-community/home-manager/release-${config.nixos-release}";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.schema.user = {
    classes = ["homeManager"];

    nixos.home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
