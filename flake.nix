{
  description = "Tomaszal Dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
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
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./nixos.nix];
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
