{
  nixpkgs.hostPlatform = "x86_64-linux";

  boot.initrd.availableKernelModules = ["ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  virtualisation.virtualbox.guest.enable = true;
}
