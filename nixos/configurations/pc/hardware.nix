{inputs, ...}: {
  nixpkgs.hostPlatform = "x86_64-linux";

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  boot.supportedFilesystems = ["ntfs"];

  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-pc-ssd

    common-cpu-amd
    common-cpu-amd-pstate
    common-cpu-amd-zenpower

    "${inputs.nixos-hardware}/common/gpu/nvidia/ampere"
  ];

  nixpkgs.config.cudaSupport = true;

  allowUnfreePackages = ["nvidia-x11" "nvidia-settings"];

  # Generate boot entries for other OS on the system, enabling dual boot
  boot.loader.grub.useOSProber = true;

  # Enable accelerated graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Mount data disk on login
  udisks.mounts = [{block-device = "/dev/disk/by-label/data";}];

  # Enable system emulation for cross-compilation
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
