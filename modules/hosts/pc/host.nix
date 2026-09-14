{den, ...}: {
  den.hosts.x86_64-linux.pc.users.tomaszal = {};

  den.aspects.pc = {
    nixos = {pkgs, ...}: {
      hardware.facter.reportPath = ./facter.json;
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };

    provides.to-users = {
      includes = with den.aspects; [
        system.emulation
        system.udisks

        dev
        dev.codex
        dev.opencode

        social

        games.steam
        games.minecraft

        system.middle-button-scroll.fenrir
      ];

      homeManager = {
        # Mount data disk on login
        udisks.mount = [{block-device = "/dev/disk/by-label/data";}];
      };
    };
  };
}
