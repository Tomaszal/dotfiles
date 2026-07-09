{
  flake-file.inputs.nur = {
    url = "github:nix-community/NUR";
    inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs-unstable";
    };
  };
}
