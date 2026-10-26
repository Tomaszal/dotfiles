{
  perSystem = {
    pkgs,
    sources,
    ...
  }: {
    # Fetch the published CLI and its runtime dependencies as one hash-pinned tree.
    packages.pulls-review-runtime =
      pkgs.runCommand "pulls.review-${sources.pulls-review.version}" {
        inherit (sources.pulls-review) version src;
        nativeBuildInputs = [pkgs.nodejs_26];
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        # Rehash with moon run repo:rehash/pulls-review after updating flake inputs.
        outputHash = "sha256-wGxspicZ3Zs8ectRXt5aJrVEmWJFzSj7dRmM1ThhKmg=";
        npm_config_cafile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        npm_config_progress = "false";
      } ''
        export HOME="$TMPDIR"
        npm install --prefix "$out" --cache "$TMPDIR/npm-cache" \
          --registry=https://registry.npmjs.org --ignore-scripts \
          --no-audit --no-fund --omit=dev "${sources.pulls-review.src}"
        rm "$out/package.json" "$out/package-lock.json" "$out/node_modules/.package-lock.json"
      '';
  };

  den.aspects.dev.agents.homeManager = {
    pkgs,
    inputs',
    self',
    ...
  }: let
    upstream = self'.packages.pulls-review-runtime;

    launcher = pkgs.writeShellApplication {
      name = "orca-review";
      runtimeInputs = [inputs'.llm-agents.packages.orca] ++ (with pkgs; [nodejs_26 git gh jq iproute2 curl coreutils]);
      text = pkgs.lib.replaceStrings ["@pullsReview@"] ["${upstream}/node_modules/pulls.review/bin.mjs"] (builtins.readFile ./orca-review.sh);
    };
  in {
    home.packages = [launcher];
  };
}
