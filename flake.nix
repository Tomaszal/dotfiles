{
  description = "Tomaszal Dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    piv-agent = {
      url = "github:smlx/piv-agent";
      flake = false;
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./src/nixos.nix];
      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = builtins.attrValues {
            inherit (pkgs) alejandra statix just nil;
          };
        };
        apps.ventoy.program = pkgs.writeShellApplication {
          name = "ventoy";
          runtimeInputs = [pkgs.ventoy-bin];
          text = "sudo ventoy-web";
        };
      };
    };
}
