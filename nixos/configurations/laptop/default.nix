{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko

    ./disko.nix

    ../../modules/common
    ../../modules/desktop
    ../../modules/programs
  ];

  networking.hostName = "laptop";

  hardware.facter.reportPath = ./facter.json;

  # Auto rotation
  hardware.sensor.iio.enable = true;
  environment.systemPackages = [pkgs.gnomeExtensions.screen-rotate];
}
