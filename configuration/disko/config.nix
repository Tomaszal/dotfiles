{disk ? null, ...}: let
  swapSize = "8G";
  partLabels = import ./part-labels.nix;
  inherit (partLabels) root boot swap;
in {
  disk.nixos = {
    device = disk;
    type = "disk";
    content = {
      type = "table";
      format = "gpt";
      partitions = [
        {
          name = boot.label;
          type = "partition";
          start = "1MiB";
          end = "100MiB";
          bootable = true;
          content = {
            type = "filesystem";
            format = "vfat";
            inherit (boot) mountpoint;
          };
        }
        {
          name = root.label;
          type = "partition";
          start = "100MiB";
          end = "-${swapSize}";
          part-type = "primary";
          content = {
            type = "filesystem";
            format = "ext4";
            inherit (root) mountpoint;
          };
        }
        {
          name = swap.label;
          type = "partition";
          start = "-${swapSize}";
          end = "100%";
          part-type = "primary";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        }
      ];
    };
  };
}
