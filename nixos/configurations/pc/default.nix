{inputs, ...}: {
  networking.hostName = "pc";

  imports = [
    inputs.disko.nixosModules.disko

    ./disko.nix
    ./hardware.nix

    ../../modules/common
    ../../modules/desktop
    ../../modules/programs
  ];
}
