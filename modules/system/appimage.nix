{
  den.default.nixos = {mv, ...}: {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    environment.systemPackages = with mv.fast.latest; [gearlever];
  };
}
