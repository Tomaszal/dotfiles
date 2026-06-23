{
  den.aspects.work = {
    host,
    user,
    ...
  }: {
    nixos = {
      boot.initrd.systemd.enable = true;
      services.displayManager.autoLogin.user = user.userName;
    };
  };
}
