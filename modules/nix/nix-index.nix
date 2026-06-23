{inputs, ...}: {
  flake-file.inputs = {
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nix-index-database.follows = "nix-index-database";
    };
  };

  den.default = {
    nixos = {pkgs, ...}: {
      imports = [inputs.nix-index-database.nixosModules.default];
      environment.systemPackages =
        (with pkgs; [comma])
        ++ [inputs.nix-alien.packages.${pkgs.system}.nix-alien];
    };

    homeManager.imports = [inputs.nix-index-database.homeModules.default];
  };
}
