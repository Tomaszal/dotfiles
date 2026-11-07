{...}: {
  den.default.nixos = {pkgs, ...}: {
    services.udev.packages = [
      (pkgs.writeTextFile {
        name = "webhid-udev-rules";
        destination = "/etc/udev/rules.d/70-webhid.rules";
        text = ''
          SUBSYSTEM=="hidraw", TAG+="uaccess"
        '';
      })
    ];
  };
}
