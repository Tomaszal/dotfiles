{
  config,
  lib,
  ...
}: {
  hm.programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ./keys/tomaszal.asc;
        trust = "ultimate";
      }
    ];
  };

  hm.services.gpg-agent = {
    # TODO: switch to `pinentryPackage` instead of `pinentryFlavor` after
    # upgrading to 24.05 to fix deprecation
    inherit (config.programs.gnupg.agent) pinentryFlavor;
    enable = true;
    enableSshSupport = true;
  };

  # Enable smart card daemon
  services.pcscd.enable = true;

  # Send a notification when YubiKey is waiting for a touch
  programs.yubikey-touch-detector.enable = true;

  # Disable default GNOME keyring, and re-enable it without SSH component
  # https://github.com/nix-community/home-manager/issues/3263#issuecomment-1913049589
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  hm.services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets"];
  };
}
