{
  den.aspects.tomaszal.homeManager = {pkgs, ...}: {
    programs.git = {
      settings.user = {
        name = "Tomas Zaluckij";
        email = "me@tomaszal.com";
      };

      settings.gpg = {
        format = "ssh";
        ssh.program = with pkgs; "${openssh}/bin/ssh-keygen";
      };

      signing.signByDefault = true;
    };
  };
}
