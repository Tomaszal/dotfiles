{
  description = "Tomaszal Dotfiles";

  inputs = {
    disko.url = "https://flakehub.com/f/nix-community/disko/1.tar.gz";
    home-manager.url = "github:nix-community/home-manager";
    nix-flatpak.url = "https://flakehub.com/f/gmodena/nix-flatpak/0.3.tar.gz";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Reduce nixpkgs instances
    # https://zimbatm.com/notes/1000-instances-of-nixpkgs
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
