{
  self,
  pkgs,
  ...
}: {
  allowUnfreePackages = [
    "steam"
    "steam-original"
    "steam-run"
  ];

  programs.steam.enable = true;

  environment.systemPackages = let
    steamGuardCli = pkgs.rustPlatform.buildRustPackage {
      name = "stemguard-cli";
      cargoSha256 = "sha256-VJ9BoMrKT3iSQS3C9/W6ZBVREryIkShv4vpLgWrInWA=";
      src = self.inputs.steamguard-cli;
    };
  in [
    steamGuardCli
  ];
}
