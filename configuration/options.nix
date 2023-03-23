{
  config,
  lib,
  ...
}: {
  options = let
    inherit (lib) mkOption types;
    inherit (types) str;
  in {
    user = {
      username = mkOption {type = str;};
      email = mkOption {type = str;};
      firstName = mkOption {type = str;};
      lastName = mkOption {type = str;};
      fullName = mkOption {
        type = str;
        default = "${config.user.firstName} ${config.user.lastName}";
      };
    };
  };
}
