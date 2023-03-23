{
  self,
  config,
  lib,
  ...
}: {
  imports = [
    self.inputs.home-manager.nixosModules.home-manager
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" "Tomaszal"])
  ];

  # Enable 'sudo' for users in 'wheel' group
  security.sudo.enable = true;

  # TODO: use Yubikey for login and disable mutable users,
  # as they are only mutable to be able to set the password
  # https://nixos.wiki/wiki/Yubikey
  users.mutableUsers = true;

  users.users.Tomaszal = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable 'sudo'
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  hm.home.stateVersion = config.system.stateVersion;
}
