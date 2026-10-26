{
  config,
  inputs,
  ...
}: {
  perSystem = {
    inputs',
    pkgs,
    pkgs-mv,
    ...
  }: rec {
    formatter = config.flake-file.formatter pkgs;

    devShells.default = pkgs.mkShell {
      # Specify Nixpkgs path for improved nixd intellisense
      NIX_PATH = ["nixpkgs=${inputs.nixpkgs}"];

      nativeBuildInputs =
        (with pkgs; [
          nixd
          nixos-facter
          nvfetcher
          ruff
        ])
        ++ [
          formatter
          inputs'.multiverse.packages.mvs
          pkgs-mv.tip.mcp-nixos
          pkgs-mv.tip.moon
          inputs'.llm-agents.packages.apm
        ];
    };
  };
}
