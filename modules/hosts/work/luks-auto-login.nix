{
  den.aspects.work = {
    host,
    user,
    ...
  }: {
    nixos = {
      config,
      lib,
      ...
    }: {
      boot.initrd.systemd.enable = true;
      services.displayManager.autoLogin.user = user.userName;

      # Autologin unlocks the GNOME login keyring using the LUKS passphrase
      # that systemd-cryptsetup cached in root's kernel keyring, so booting
      # only ever asks for one password. Upstream wires this up with GDM's
      # pam_gdm.so (NixOS/nixpkgs#282317), but gdm 50.2 bounded its keyring
      # buffer walk and broke reading systemd's NUL-separated password list.
      # Use systemd's own module instead, as NixOS/nixpkgs#286587 proposes.
      security.pam.services.gdm-autologin.rules.auth = {
        gdm.enable = lib.mkForce false;

        systemd_loadkey = {
          order = config.security.pam.services.gdm-autologin.rules.auth.gnome_keyring.order - 10;
          control = "optional";
          modulePath = "${config.systemd.package}/lib/security/pam_systemd_loadkey.so";
        };
      };
    };
  };
}
