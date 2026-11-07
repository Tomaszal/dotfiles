{
  den.default = {
    nixos = {pkgs, ...}: {
      hardware.i2c.enable = true;
      environment.systemPackages = with pkgs; [ddcutil];
    };

    homeManager = {pkgs, ...}: {
      programs.gnome-shell.extensions = [
        {package = pkgs.gnomeExtensions.brightness-control-using-ddcutil;}
      ];
    };
  };
}
