{
  nixpkgs.hostPlatform = "x86_64-linux";

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  # Generate boot entries for other OS on the system, enabling dual boot
  boot.loader.grub.useOSProber = true;

  # AMD CPU fixes
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Nvidia GPU fixes
  allowUnfreePackages = ["nvidia-x11" "nvidia-settings"];
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    powerManagement.enable = true;
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Mount data disk on login
  udisks.mounts = [{block-device = "/dev/disk/by-label/data";}];
}
