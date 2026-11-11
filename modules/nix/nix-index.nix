{inputs, ...}: {
  flake-file.inputs = {
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs = {
        flake-compat.follows = "flake-compat";
        nix-index-database.follows = "nix-index-database";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  den.default = {
    nixos = {
      inputs',
      mv,
      ...
    }: {
      imports = [inputs.nix-index-database.nixosModules.default];
      environment.systemPackages =
        (with mv.fast.latest; [comma])
        ++ [inputs'.nix-alien.packages.nix-alien];
    };

    homeManager.imports = [inputs.nix-index-database.homeModules.default];
  };
}
