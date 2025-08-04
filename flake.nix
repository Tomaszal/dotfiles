{
  description = "Tomaszal Dotfiles";

  inputs = {
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";
    keys.url = "github:tomaszal/keys";
    keys.inputs.flake-parts.follows = "flake-parts";
    keys.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./src/nixos.nix];
      systems = ["x86_64-linux"];
      perSystem = {
        pkgs,
        inputs',
        ...
      }: {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            alejandra
            fh
            just
            nil
            statix
          ];
        };

        apps.ventoy.program = pkgs.writeShellApplication {
          name = "ventoy";
          runtimeInputs = [pkgs.ventoy-bin];
          text = "sudo ventoy-web";
        };
      };
    };
}
