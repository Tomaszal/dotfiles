{
  modulesPath,
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";

  imports = ["${modulesPath}/profiles/qemu-guest.nix"];

  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  services.xserver.videoDrivers = lib.mkIf config.services.xserver.enable ["qxl"];
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Needed to make SPICE work on KDE:
  # https://www.reddit.com/r/NixOS/comments/yv0nge/spicevdagent_is_broken_on_unstable/
  systemd.user.services.spice-vdagent = {
    enable = true;
    description = "spice-vdagent session";
    after = ["graphical-session-pre.target"];
    partOf = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent";
    };
  };
}
