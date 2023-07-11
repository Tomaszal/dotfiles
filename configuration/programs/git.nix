{
  config,
  pkgs,
  ...
}: let
  inherit (config.user) username fullName email;

  getGpgFingerprintFromAsc' = file:
    pkgs.stdenv.mkDerivation {
      name = "gpg-fingerprint-${baseNameOf file}";
      phases = ["installPhase"];
      buildInputs = [pkgs.gnupg];
      installPhase = ''
        mkdir -p $out homeless-shelter
        HOME=$(pwd)/homeless-shelter

        gpg --show-keys --with-colons --with-fingerprint ${file} \
          | sed -n 2p | cut -d ':' -f 10 | tr -d "\n" \
          >$out/fingerprint
      '';
    };

  getGpgFingerprintFromAsc = file: builtins.readFile "${(getGpgFingerprintFromAsc' file)}/fingerprint";
in {
  hm.programs.git = {
    enable = true;

    extraConfig.user.username = username;
    userName = fullName;
    userEmail = email;

    signing = {
      key = getGpgFingerprintFromAsc ../../keys/tomaszal-piv-agent.asc;
      signByDefault = true;
    };
  };
}
