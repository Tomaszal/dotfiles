{config, ...}: let
  inherit (config.user) username fullName email;
in {
  hm.programs.git = {
    enable = true;

    extraConfig.user.username = username;
    userName = fullName;
    userEmail = email;
  };
}
