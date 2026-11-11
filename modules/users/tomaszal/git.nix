{
  den.aspects.tomaszal.homeManager = {mv, ...}: {
    programs.git = {
      settings.user = {
        name = "Tomas Zaluckij";
        email = "me@tomaszal.com";
      };

      settings.gpg = {
        format = "ssh";
        ssh.program = "${mv.fast.latest.openssh}/bin/ssh-keygen";
      };

      signing.signByDefault = true;
    };
  };
}
