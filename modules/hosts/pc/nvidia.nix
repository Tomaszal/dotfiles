{den, ...}: {
  den.aspects.pc = {
    includes = [(den.batteries.unfree ["nvidia-x11" "nvidia-settings"])];

    nixos = {lib, ...}: {
      services.xserver.videoDrivers = ["nvidia"];
      hardware.nvidia.open = true;
      hardware.nvidia.powerManagement.enable = true;

      virtualisation.vmVariant = {
        boot.initrd.kernelModules = lib.mkForce [];
        services.xserver.videoDrivers = lib.mkForce ["modesetting"];
        hardware.nvidia.open = lib.mkForce false;
        hardware.nvidia.powerManagement.enable = lib.mkForce false;
      };
    };
  };
}
