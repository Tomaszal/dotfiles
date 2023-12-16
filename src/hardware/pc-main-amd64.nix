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
  services.xserver.videosDrivers = ["nvidia"];
  hardware.nvidia.modesetting.enable = true;
  programs.hyprland.enableNvidiaPatches = true;
  hm.wayland.windowManager.hyprland.enableNvidiaPatches = true;
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
