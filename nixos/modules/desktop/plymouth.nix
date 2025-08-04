{
  # Enable flicker free boot
  boot.plymouth.enable = true;

  # Hide GRUB, hold shift during boot to show it
  boot.loader.timeout = 1;
  boot.loader.grub.splashImage = null;
  boot.loader.grub.timeoutStyle = "hidden";

  # Reduce boot log verbosity
  boot.kernelParams = ["quiet" "rd.udev.log_level=3"];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
}
