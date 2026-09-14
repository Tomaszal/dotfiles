{inputs, ...}: {
  perSystem = {
    inputs',
    pkgs,
    pkgs-mv,
    ...
  }: {
    formatter = with pkgs; alejandra;

    devShells.default = pkgs.mkShell {
      # Specify Nixpkgs path for improved nixd intellisense
      NIX_PATH = ["nixpkgs=${inputs.nixpkgs}"];

      nativeBuildInputs =
        (with pkgs; [
          alejandra
          nixd
          nixos-facter
          nvfetcher
          ruff
        ])
        ++ [
          inputs'.multiverse.packages.mvs
          pkgs-mv.tip.mcp-nixos
        ];
    };
  };
}
