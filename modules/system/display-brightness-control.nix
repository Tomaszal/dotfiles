{
  den.default = {
    nixos = {mv, ...}: {
      hardware.i2c.enable = true;
      environment.systemPackages = with mv.fast.latest; [ddcutil];
    };

    homeManager = {pkgs, ...}: {
      programs.gnome-shell.extensions = [
        {package = pkgs.gnomeExtensions.brightness-control-using-ddcutil;}
      ];
    };
  };
}
