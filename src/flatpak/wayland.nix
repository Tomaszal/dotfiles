{
  self,
  lib,
  config,
  ...
}: {
  options = let
    inherit (lib) mkOption types;
    inherit (types) str listOf attrsOf;
  in {
    flatpak.wayland = {
      blacklist = mkOption {
        type = listOf str;
        description = "Disable Wayland (force X11) for listed packages";
        default = [];
      };

      electronFlagsFiles = mkOption {
        type = attrsOf str;
        description = "Generate flag files that enable native Wayland support in listed Electron packages";
        default = {};
      };
    };
  };

  config = let
    inherit (config.flatpak.wayland) blacklist electronFlagsFiles;
    hmLib = self.inputs.home-manager.lib.hm;
  in {
    hm.services.flatpak.overrides =
      {
        global = {
          # Force Wayland socket
          Context.sockets = ["wayland" "!x11" "!fallback-x11"];

          # Fix un-themed cursor in some Wayland apps
          # https://github.com/flathub/com.spotify.Client/issues/239#issuecomment-1616250683
          Environment.XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        };
      }
      // (lib.trivial.pipe blacklist [
        (builtins.map (package: {
          name = package;
          value = {Context.sockets = ["x11"];};
        }))
        builtins.listToAttrs
      ]);

    hm.home.activation.flatpakWaylandElectronFlags = lib.trivial.pipe electronFlagsFiles [
      (let
        flags = builtins.toFile "flags.conf" ''
          --enable-features=UseOzonePlatform,WaylandWindowDecorations
          --ozone-platform=wayland
        '';
      in
        # Create physical files, as symlinks are ignored
        builtins.mapAttrs (package: file: ''
          mkdir -p $HOME/.var/app/${package}/config
          cat ${flags} > $HOME/.var/app/${package}/config/${file}
        ''))
      builtins.attrValues
      (builtins.concatStringsSep "\n")
      (hmLib.dag.entryAfter ["flatpak-managed-install"])
    ];
  };
}
