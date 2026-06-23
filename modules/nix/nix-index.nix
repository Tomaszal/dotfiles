{inputs, ...}: {
  flake-file.inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  den.default = {
    nixos = {pkgs, ...}: {
      imports = [inputs.nix-index-database.nixosModules.default];
      environment.systemPackages = with pkgs; [comma];
    };

    homeManager.imports = [inputs.nix-index-database.homeModules.default];
  };
}
