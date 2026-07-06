{inputs, ...}: {
  perSystem = {
    pkgs,
    pkgs-unstable,
    ...
  }: {
    formatter = with pkgs; alejandra;

    devShells.default = pkgs.mkShell {
      # Specify Nixpkgs path for improved nixd intellisense
      NIX_PATH = ["nixpkgs=${inputs.nixpkgs}"];

      nativeBuildInputs = with pkgs; [
        alejandra
        nixd
        nixos-facter
        pkgs-unstable.mcp-nixos
      ];
    };
  };
}
