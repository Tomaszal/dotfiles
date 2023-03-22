let
  partLabels = import ./part-labels.nix;
  inherit (partLabels) root boot swap;
  getDevice = label: "/dev/disk/by-partlabel/${label}";
in {
  # imports = [self.inputs.disko.nixosModules.disko];
  # disko.devices = import ./config.nix {};

  fileSystems.${root.mountpoint}.device = getDevice root.label;
  fileSystems.${boot.mountpoint}.device = getDevice boot.label;

  swapDevices = [{device = getDevice swap.label;}];
}
