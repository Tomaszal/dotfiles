{
  self,
  pkgs,
  lib,
  modulesPath,
  ...
}: let
  name = "nixos-installer";
  installScript = pkgs.writeShellApplication {
    name = "nixos-install-flake";
    text = ''nixos-install --flake "${../../.}#$1" "''${@:2}"'';
  };
  justfile = pkgs.writeShellApplication {
    name = "just";
    runtimeInputs = [pkgs.just];
    text = ''
      export JUSTFILE=${./justfile}
      just --justfile $JUSTFILE "$@"
    '';
  };
in {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ../kernel.nix
    ../nix.nix
    ../disko/format.nix
  ];

  isoImage.isoName = lib.mkForce "${name}.iso";
  isoImage.volumeID = "${name}";

  # Save NixOS derivations on ISO to speed up system install
  isoImage.storeContents =
    map
    (nixos: nixos.config.system.build.toplevel)
    (builtins.attrValues self.nixosConfigurations);

  # Speed up image build and system install
  isoImage.squashfsCompression = "zstd -Xcompression-level 6";
  isoImage.compressImage = false;

  environment.noXlibs = false;
  environment.systemPackages = [installScript justfile];
}
