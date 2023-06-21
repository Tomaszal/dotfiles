{inputs, ...}: {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: let
    channel = "candidate"; # stable/candidate/edge
  in {
    apps.updateSpotify.program = pkgs.writeShellApplication {
      name = "update-spotify";
      runtimeInputs = [
        pkgs.curl
        pkgs.jq
        inputs'.nvfetcher.packages.default
      ];
      text = ''
        SPOTIFY_NIX_DIR=./configuration/programs/spotify

        curl -s -H 'X-Ubuntu-Series: 16' \
          "https://api.snapcraft.io/api/v1/snaps/details/spotify?channel=${channel}" \
          | jq '{ revision: .revision|tostring, sha512: .download_sha512, upstream_version: .version }' \
          > $SPOTIFY_NIX_DIR/version.json

        nvfetcher --config ${inputs.spicetify-nix}/pkgs/nvfetcher.toml --build-dir $SPOTIFY_NIX_DIR/sources
      '';
    };
  };
}
