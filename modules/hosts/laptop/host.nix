{den, ...}: {
  den.hosts.x86_64-linux.laptop.users.tomaszal = {};

  den.aspects.laptop = {
    nixos = {pkgs, ...}: {
      hardware.facter.reportPath = ./facter.json;

      # Auto rotation
      hardware.sensor.iio.enable = true;
      environment.systemPackages = [pkgs.gnomeExtensions.screen-rotate];
    };

    provides.to-users.includes = with den.aspects; [
      social
    ];
  };
}
