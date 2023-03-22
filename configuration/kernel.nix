{
  self,
  pkgs,
  lib,
  ...
}: {
  # Use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Disable ZFS (to avoid warnings)
  nixpkgs.overlays = [
    (final: super: {zfs = super.zfs.overrideAttrs (_: {meta.platforms = [];});})
  ];

  # Sync NixOS configuration revision to the Flake's Git revision
  system.configurationRevision = lib.mkIf (self ? rev) self.rev;
}
