{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko

    ./disko.nix

    ../../modules/common
    ../../modules/desktop
    ../../modules/programs
  ];

  networking.hostName = "work";

  hardware.facter.reportPath = ./facter.json;
}
