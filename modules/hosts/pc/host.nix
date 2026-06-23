{den, ...}: {
  den.hosts.x86_64-linux.pc.users.tomaszal = {};

  den.aspects.pc.provides.to-users = {
    includes = with den.aspects; [
      system.emulation
      system.udisks

      dev
      dev.opencode

      social.personal

      games.steam
      games.minecraft
    ];

    nixos = {
      hardware.facter.reportPath = ./facter.json;
    };

    homeManager = {
      # Mount data disk on login
      udisks.mount = [{block-device = "/dev/disk/by-label/data";}];
    };
  };
}
