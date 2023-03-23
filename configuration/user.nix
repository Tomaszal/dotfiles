{
  self,
  config,
  lib,
  ...
}: {
  imports = [
    self.inputs.home-manager.nixosModules.home-manager
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.user.username])
  ];

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
}
