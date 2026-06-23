{
  flake-file.inputs.home-manager = {
    url = "github:nix-community/home-manager/release-25.11";
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
