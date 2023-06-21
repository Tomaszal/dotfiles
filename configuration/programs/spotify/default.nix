{
  self,
  pkgs,
  lib,
  ...
}: let
  spotifyDerivation = let
    version = lib.importJSON ./version.json;
    inherit (version) revision sha512 upstream_version;
  in
    pkgs.stdenv.mkDerivation {
      name = "spotify-updated-derivation";
      src = "${self.inputs.nixpkgs}/pkgs/applications/audio/spotify";
      phases = ["unpackPhase" "installPhase"];
      installPhase = ''
        mkdir -p $out
        cp -a ./. $out/
        sed --regexp-extended \
          -e 's/rev\s*=\s*"[0-9]+"\s*;/rev = "'${revision}'";/' \
          -e 's/sha512\s*=\s*"[^"]*"\s*;/sha512 = "'${sha512}'";/' \
          -e 's/version\s*=\s*".*"\s*;/version = "'${upstream_version}'";/' \
          -i $out/linux.nix
      '';
    };

  spotify = pkgs.callPackage spotifyDerivation {};

  spicetifyNix = pkgs.stdenv.mkDerivation {
    name = "spicetify-nix-updated";
    src = self.inputs.spicetify-nix;
    phases = ["unpackPhase" "installPhase"];
    installPhase = ''
      mkdir -p $out
      cp -a ./. $out/
      cp -a ${./sources}/. $out/pkgs/_sources/
    '';
  };

  spicetifyPkgs = pkgs.callPackage "${spicetifyNix}/pkgs" {};
  spicetifyHomeManagerModule = (import "${spicetifyNix}/module.nix") {isNixOSModule = false;};

  inherit (spicetifyPkgs) apps extensions themes;
in {
  allowUnfreePackages = ["spotify"];

  hm.imports = [spicetifyHomeManagerModule];

  hm.programs.spicetify = {
    enable = true;

    spotifyPackage = spotify;

    # Available themes: https://github.com/the-argus/spicetify-nix/blob/master/THEMES.md
    theme = themes.Dribbblish;
    colorScheme = "rosepine";

    # Available custom apps: https://github.com/the-argus/spicetify-nix/blob/master/CUSTOMAPPS.md
    enabledCustomApps = builtins.attrValues {
      inherit
        (apps)
        marketplace
        reddit
        ;
    };

    # Available extensions: https://github.com/the-argus/spicetify-nix/blob/master/EXTENSIONS.md
    enabledExtensions = builtins.attrValues {
      inherit
        (extensions)
        autoSkip
        genre
        groupSession
        history
        keyboardShortcut
        playNext
        popupLyrics
        seekSong
        shuffle
        skipStats
        songStats
        trashbin
        volumePercentage
        ;
    };
  };
}
