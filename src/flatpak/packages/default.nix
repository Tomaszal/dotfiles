{
  imports = [
    ./wayland.nix
  ];

  hm.services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
    "com.parsecgaming.parsec"
    "com.spotify.Client"
    "io.github.spacingbat3.webcord"
    "it.mijorus.smile"
    "org.chromium.Chromium"
    "org.mozilla.firefox"
    "org.onlyoffice.desktopeditors"
    "org.telegram.desktop"
  ];
}
