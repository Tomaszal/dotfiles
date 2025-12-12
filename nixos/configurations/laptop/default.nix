{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-facter-modules.nixosModules.facter

    ./disko.nix

    ../../modules/common
    ../../modules/desktop
    ../../modules/programs
  ];

  networking.hostName = "laptop";

  facter.reportPath = ./facter.json;

  # Auto rotation
  hardware.sensor.iio.enable = true;
  environment.systemPackages = [pkgs.gnomeExtensions.screen-rotate];
}
