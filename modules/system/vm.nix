{
  den.default.nixos.virtualisation.vmVariant.virtualisation = {
    memorySize = 4096;
    cores = 2;
    diskSize = 8192;
  };

  den.schema.host.includes = [
    ({user, ...}: {
      nixos.virtualisation.vmVariant = {
        config,
        lib,
        mv,
        ...
      }: let
        password = "vm";
      in {
        services.displayManager.autoLogin = {
          enable = true;
          user = user.userName;
        };
        users.users.${user.userName}.initialPassword = password;

        # Pass the VM password to GNOME Keyring through PAM during autologin.
        systemd.services.display-manager.preStart = ''
          printf '%s\0' ${lib.escapeShellArg password} | ${mv.fast.latest.keyutils}/bin/keyctl padd user vm-autologin @u
        '';

        security.pam.services.gdm-autologin.rules.auth = {
          gdm.enable = lib.mkForce false;
          systemd_loadkey = {
            order = config.security.pam.services.gdm-autologin.rules.auth.gnome_keyring.order - 10;
            control = "optional";
            modulePath = "${config.systemd.package}/lib/security/pam_systemd_loadkey.so";
            settings.keyname = "vm-autologin";
          };
        };
      };
    })
  ];
}
