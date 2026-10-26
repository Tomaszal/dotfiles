{
  perSystem = {
    pkgs,
    sources,
    ...
  }: {
    packages.pulls-review-runtime = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "pulls-review-runtime";
      inherit (sources.pulls-review) version src;
      nativeBuildInputs = [pkgs.nodejs_26 pkgs.pnpm_12 pkgs.pnpmConfigHook];
      pnpmDeps = pkgs.fetchPnpmDeps {
        inherit (finalAttrs) pname version src;
        pnpm = pkgs.pnpm_12;
        fetcherVersion = 4;
        hash = "sha256-uO2kwwsieak6WxJjasJkNWkoF5LfkBkKZ20gtEta7kw=";
      };
      buildPhase = ''
        runHook preBuild
        pnpm --filter @pulls.review/core run build
        pnpm --filter pulls.review run build
        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall
        pnpm --filter pulls.review --config.inject-workspace-packages=true deploy --prod --offline "$out"
        runHook postInstall
      '';
      doInstallCheck = true;
      installCheckPhase = ''
        runHook preInstallCheck
        node "$out/bin.mjs" --help
        test -s "$out/dist/client/index.html"
        runHook postInstallCheck
      '';
    });
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
      text = pkgs.lib.replaceStrings ["@pullsReview@"] ["${upstream}/bin.mjs"] (builtins.readFile ./review.sh);
    };
  in {
    home.packages = [launcher];
  };
}
