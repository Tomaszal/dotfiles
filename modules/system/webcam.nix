{
  den.default.nixos = {mv, ...}: {
    environment.systemPackages = with mv.fast.latest; [cameractrls-gtk3];
  };
}
