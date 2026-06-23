{lib, ...}: {
  den.aspects.system.udisks = {
    nixos = {
      security.polkit.enable = true;

      # Add some permissions to wheel group users, to avoid requiring
      # authorization on every action
      # https://github.com/coldfix/udiskie/wiki/Permissions
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          var YES = polkit.Result.YES;

          var permission = {
            "org.freedesktop.udisks2.filesystem-mount": YES,
            "org.freedesktop.udisks2.filesystem-mount-system": YES,

            "org.freedesktop.udisks2.eject-media": YES,
            "org.freedesktop.udisks2.eject-media-system": YES,

            "org.freedesktop.udisks2.power-off-drive": YES,
            "org.freedesktop.udisks2.power-off-drive-system": YES,
          };

          if (subject.isInGroup("wheel")) {
            return permission[action.id];
          }
        });
      '';
    };

    homeManager = {
      pkgs,
      config,
      ...
    }: let
      inherit (lib.trivial) pipe concat;
      inherit (lib.strings) optionalString concatStrings concatLines;
      inherit (lib.attrsets) mapAttrsToList genAttrs;
      inherit (lib) mkOption types;
      inherit (types) nullOr str listOf submodule;
    in {
      options.udisks.mount = mkOption {
        type = nullOr (listOf (submodule {
          options =
            genAttrs
            ["object-path" "block-device" "filesystem-type" "options"]
            (argument:
              mkOption {
                type = nullOr str;
                default = null;
              });
        }));
        description = "Mount file-systems on login using udisks";
        default = null;
      };

      config.systemd.user.services.udisks-mount = let
        mount = config.udisks.mount;
      in
        lib.mkIf (mount != null) {
          Unit.After = ["graphical-session.target"];
          Install.WantedBy = ["graphical-session.target"];
          Service.ExecStart = pipe mount [
            (map (mount:
              pipe mount [
                (mapAttrsToList (argument: value: optionalString (value != null) " --${argument} ${value}"))
                (concat ["${pkgs.udisks}/bin/udisksctl mount --no-user-interaction"])
                concatStrings
              ]))
            concatLines
            (pkgs.writeShellScript "udisks-mount")
          ];
        };
    };
  };
}
