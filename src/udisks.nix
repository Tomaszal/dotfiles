{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.trivial) pipe concat;
  inherit (lib.strings) optionalString concatStrings concatLines;
  inherit (lib.attrsets) mapAttrsToList genAttrs;
in {
  options = let
    inherit (lib) mkOption types;
    inherit (types) nullOr str listOf submodule;
  in {
    udisks.mounts = mkOption {
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
  };

  config = {
    hm.systemd.user.services.udisks-mounts = let
      mountList = config.udisks.mounts;
    in
      lib.mkIf (mountList != null) {
        Unit.After = ["graphical-session.target"];
        Install.WantedBy = ["graphical-session.target"];
        Service.ExecStart = pipe mountList [
          (map (mount:
            pipe mount [
              (mapAttrsToList (argument: value: optionalString (value != null) " --${argument} ${value}"))
              (concat ["${pkgs.udisks}/bin/udisksctl mount --no-user-interaction"])
              concatStrings
            ]))
          concatLines
          (pkgs.writeShellScript "udisks-mounts")
        ];
      };
  };
}
