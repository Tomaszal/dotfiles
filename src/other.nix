{pkgs, ...}: {
  allowUnfreePackages = [
    "discord"
    "parsec-bin"
    "slack"
    "spotify"
    "steam-unwrapped"
    "steam"
    "teamviewer"
  ];

  services.teamviewer.enable = true;

  programs.nix-ld.enable = true;

  hm.programs = {
    firefox.enable = true;
    chromium.enable = true;
    obs-studio.enable = true;
  };

  hm.home.packages = with pkgs; [
    cameractrls-gtk3
    discord
    libreoffice
    pinta
    prismlauncher
    signal-desktop
    slack
    smile
    spotify
    telegram-desktop
    vlc
  ];
}
