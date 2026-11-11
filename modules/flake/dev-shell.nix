{
  config,
  inputs,
  ...
}: {
  perSystem = {
    inputs',
    pkgs,
    mv,
    ...
  }: rec {
    formatter = config.flake-file.formatter pkgs;

    devShells.default = pkgs.mkShell {
      MOON_TOOLCHAIN_FORCE_GLOBALS = "true";

      # Specify Nixpkgs path for improved nixd intellisense
      NIX_PATH = ["nixpkgs=${inputs.nixpkgs}"];

      nativeBuildInputs =
        (with mv.fast.latest; [
          nixd
          nixos-facter
          nvfetcher
          nix-update
          ruff
        ])
        ++ [
          formatter
          inputs'.multiverse.packages.mvs
          mv.fast.latest.mcp-nixos
          mv.fast.latest.moon
          inputs'.llm-agents.packages.apm
        ];
    };
  };
}
