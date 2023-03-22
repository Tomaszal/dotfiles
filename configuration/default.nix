{
  imports = [
    ./kernel.nix
    ./nix.nix
    ./disko/mount.nix
    ./kde.nix
  ];

  time.timeZone = "Europe/London";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Enable 'sudo' for users in 'wheel' group
  security.sudo.enable = true;

  # TODO: use Yubikey for login and disable mutable users,
  # as they are only mutable to be able to set the password
  # https://nixos.wiki/wiki/Yubikey
  users.mutableUsers = true;

  users.users.tomaszal = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable 'sudo'
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
