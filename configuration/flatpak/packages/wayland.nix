{
  # Disable wayland for packages that have no support for it
  flatpak.wayland.blacklist = [
    "com.parsecgaming.parsec"
    "org.onlyoffice.desktopeditors"
  ];

  # Enable native Wayland mode for Electron packages
  flatpak.wayland.electronFlagsFiles = {
    "com.spotify.Client" = "spotify-flags.conf";
    "org.chromium.Chromium" = "chromium-flags.conf";
  };

  # Enable native Wayland mode for Firefox
  hm.services.flatpak.overrides."org.mozilla.firefox".Environment.MOZ_ENABLE_WAYLAND = "1";
}
