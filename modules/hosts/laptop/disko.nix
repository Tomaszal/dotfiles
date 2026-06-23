{
  den.aspects.laptop.nixos.disko.devices.disk.nixos = {
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          type = "EF00"; # EFI system partition
          size = "4G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        swap = {
          type = "8200"; # Linux swap
          size = "8G";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
