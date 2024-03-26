{pkgs, ...}: {
  hardware.i2c.enable = true;
  environment.systemPackages = with pkgs; [
    ddcutil
    gnomeExtensions.brightness-control-using-ddcutil
  ];
}
