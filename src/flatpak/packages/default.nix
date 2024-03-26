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
    "net.nokyan.Resources"
    "org.chromium.Chromium"
    "org.mozilla.firefox"
    "org.onlyoffice.desktopeditors"
    "org.telegram.desktop"
    # "io.missioncenter.MissionCenter" replaced by Resources, as currently broken https://gitlab.com/mission-center-devs/mission-center/-/issues/85
  ];
}
