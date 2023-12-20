{
  self,
  pkgs,
  config,
  ...
}: let
  hmLib = self.inputs.home-manager.lib.hm;
  appId = "com.visualstudio.code";
in {
  hm.services.flatpak = {
    packages = [appId];
    overrides.${appId} = {
      Context = {
        filesystems = [
          "/run/current-system/sw/bin:ro" # Expose host binaries
          "xdg-config/git:ro" # Expose user Git config
          "xdg-config/direnv:ro" # Expose user direnv config
        ];
        sockets = [
          "gpg-agent" # Expose GPG agent
          "pcsc" # Expose smart cards (i.e. YubiKey)
        ];
      };

      # Expose host binaries
      Environment.EXTRA_PATH =
        builtins.concatStringsSep ":"
        [
          # TODO: see if there is a way to get whole PATH managed by NixOS
          "/var/run/host/etc/static/profiles/per-user/${config.user.username}/bin"
          "/run/current-system/sw/bin"
        ];
    };
  };

  # TODO: remove patch when merged upstream
  hm.home.activation.patchVSCode = hmLib.dag.entryAfter ["flatpak-managed-install"] ''
    ${pkgs.gnupatch}/bin/patch --forward --batch \
      ''${XDG_DATA_HOME:-$HOME/.local/share}/flatpak/app/${appId}/current/active/files/bin/code \
      ${./flatpak-entrypoint.patch} \
      || true
  '';

  # Enable native Wayland mode
  flatpak.wayland.electronFlagsFiles.${appId} = "code-flags.conf";
}
