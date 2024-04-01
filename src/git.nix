{
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (config.user) fullName email;
in {
  hm.programs.git = {
    enable = true;

    userName = fullName;
    userEmail = email;

    extraConfig.gpg = {
      format = "ssh";
      ssh.program = "${pkgs.openssh}/bin/ssh-keygen";
    };

    signing = {
      key = toString inputs.keys.ssh.yubikey.piv-agent.touch-policy.always;
      signByDefault = true;
    };
  };
}
