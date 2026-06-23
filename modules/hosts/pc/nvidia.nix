{den, ...}: {
  den.aspects.pc = {
    includes = [(den.batteries.unfree ["nvidia-x11" "nvidia-settings"])];

    nixos = {
      services.xserver.videoDrivers = ["nvidia"];
      hardware.nvidia.open = true;
      hardware.nvidia.powerManagement.enable = true;
    };
  };
}
