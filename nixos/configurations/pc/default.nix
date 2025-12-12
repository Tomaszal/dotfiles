{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-facter-modules.nixosModules.facter

    ./disko.nix

    ../../modules/common
    ../../modules/desktop
    ../../modules/programs
  ];

  networking.hostName = "pc";

  facter.reportPath = ./facter.json;

  # NTFS support
  boot.supportedFilesystems = ["ntfs"];

  # NVIDIA drivers
  services.xserver.videoDrivers = ["nvidia"];
  allowUnfreePackages = ["nvidia-x11" "nvidia-settings"];
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;

  # Generate boot entries for dual booting other OS's
  boot.loader.grub.useOSProber = true;

  # Mount data disk on login
  udisks.mounts = [{block-device = "/dev/disk/by-label/data";}];

  # System emulation for cross-compilation
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
