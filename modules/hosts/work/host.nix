{den, ...}: {
  den.hosts.x86_64-linux.work.users.tomaszal = {};

  den.aspects.work.provides.to-users = {
    includes = with den.aspects; [
      dev
      dev.docker
      dev.postman
      dev.claude-code
      dev.opencode

      social.work

      (den.aspects.media.flameshot {screen = 1;})
    ];

    nixos = {pkgs, ...}: {
      hardware.facter.reportPath = ./facter.json;
      boot.kernelPackages = pkgs.linuxPackages_latest;
      services.fwupd.enable = true;
    };
  };
}
