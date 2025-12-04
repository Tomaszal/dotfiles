{inputs, ...}: {
  networking.hostName = "laptop";

  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-facter-modules.nixosModules.facter

    ./disko.nix

    ../../modules/common
    ../../modules/desktop
    ../../modules/programs
  ];

  facter.reportPath = ./facter.json;
}
