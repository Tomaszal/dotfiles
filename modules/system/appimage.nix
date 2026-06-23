{
  den.default.nixos = {pkgs, ...}: {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    environment.systemPackages = with pkgs; [gearlever];
  };
}
