{pkgs, ...}: {
  imports = [
    ./kernel.nix
    ./nix.nix
    ./disko/mount.nix
    ./options.nix
    ./user.nix
    ./programs
    ./plymouth.nix
    ./flatpak
  ];

  time.timeZone = "Europe/London";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };

  # Enable sound with pipewire
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages =
    (with pkgs; [
      prismlauncher
    ])
    ++ (with pkgs.libsForQt5; [
      # Useful KDE apps
      ark
      dolphin-plugins
      dolphin
      filelight
      gwenview
      kate
      kcalc
      kinfocenter
      konsole
      ksystemstats
      okular
      plasma-systemmonitor
      qt5ct
    ]);
}
