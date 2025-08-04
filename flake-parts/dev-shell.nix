{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      # Specify Nixpkgs path for improved nixd intellisense
      NIX_PATH = ["nixpkgs=${inputs.nixpkgs}"];

      nativeBuildInputs = with pkgs; [
        alejandra
        nixd
      ];
    };
  };
}
