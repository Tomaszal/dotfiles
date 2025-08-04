# TODO: offline installer
# https://gitlab.com/genericnerdyusername/nixos-installer-gen
# https://github.com/nix-community/disko/blob/master/docs/disko-install.md#using-disko-install-in-an-offline-installer
{
  lib,
  modulesPath,
  pkgs,
  self,
  ...
}: let
  name = "nixos-installer";
  installScript = pkgs.writeShellApplication {
    name = "nixos-install-flake";
    text = ''nixos-install --flake "${self}#$1" "''${@:2}"'';
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
    ../../modules/common
  ];

  isoImage.isoName = lib.mkForce "${name}.iso";
  isoImage.volumeID = "${name}";

  # Save NixOS derivations on ISO to speed up system install
  # isoImage.storeContents =
  #   builtins.concatMap
  #   (nixos: with nixos.config.system; [path build.toplevel] ++ extraDependencies)
  #   (builtins.attrValues self.nixosConfigurations);

  environment.systemPackages = with pkgs; [
    disko
    installScript
    justfile
  ];
}
