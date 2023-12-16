{
  self,
  config,
  lib,
  ...
}: {
  # Setup Home Manager and a config alias for the main user
  # TODO: update HM to fix the optionsDocBook deprecation warning once this issue is resolved:
  # https://github.com/nix-community/home-manager/issues/4273
  imports = [
    self.inputs.home-manager.nixosModules.home-manager
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.user.username])
  ];

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

  config = {
    user = {
      username = "Tomaszal";
      email = "tz@tomaszal.com";
      firstName = "Tomas";
      lastName = "Zaluckij";
    };

    # Enable 'sudo' for users in 'wheel' group
    security.sudo.enable = true;

    # TODO: use Yubikey for login and disable mutable users,
    # as they are only mutable to be able to set the password
    # https://nixos.wiki/wiki/Yubikey
    users.mutableUsers = true;

    users.users.${config.user.username} = {
      isNormalUser = true;
      extraGroups = ["wheel"]; # Enable 'sudo'
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    hm.home.stateVersion = config.system.stateVersion;
  };
}
