{
  # TODO: move all inputs next to where they are actually used
  flake-file.inputs = {
    disko.url = "github:nix-community/disko/latest";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    keys.url = "github:tomaszal/keys";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nix-index-database.url = "github:nix-community/nix-index-database";

    # Follows
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";
    keys.inputs.flake-parts.follows = "flake-parts";
    keys.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
}
