{
  den.default.nixos.boot = {
    # Enable flicker free boot
    plymouth.enable = true;

    # Hide GRUB, hold shift during boot to show it
    loader.timeout = 1;
    loader.grub.splashImage = null;
    loader.grub.timeoutStyle = "hidden";

    # Reduce boot log verbosity
    kernelParams = ["quiet" "rd.udev.log_level=3"];
    consoleLogLevel = 3;
    initrd.verbose = false;
  };
}
