{
  den.default.nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [cameractrls-gtk3];
  };
}
