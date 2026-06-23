# TODO: offline installer
# https://gitlab.com/genericnerdyusername/nixos-installer-gen
# https://github.com/nix-community/disko/blob/master/docs/disko-install.md#using-disko-install-in-an-offline-installer
{
  den,
  inputs,
  lib,
  self,
  ...
}: {
  perSystem = {system, ...}: let
    module = den.lib.aspects.resolve "nixos" den.aspects.installer;
  in {
    packages.installer =
      (inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [module];
      }).config.system.build.isoImage;
  };

  den.aspects.installer.nixos = {
    modulesPath,
    pkgs,
    ...
  }: let
    name = "nixos-installer";
  in {
    imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];

    image.baseName = lib.mkForce name;
    isoImage.volumeID = name;

    # isoImage.contents = [
    #   {
    #     source = self;
    #     target = "flake";
    #   }
    # ];

    isoImage.squashfsCompression = "gzip -Xcompression-level 1";

    networking.networkmanager.enable = true;

    environment.variables.FLAKE = self;

    environment.systemPackages = with pkgs; [
      disko
      nixos-facter
    ];

    users.motd = ''
      Welcome to the NixOS installer!

      To proceed with the installation, run the following command:

      disko-install --flake $FLAKE --disk nixos /dev/disk-path
    '';
  };
}
