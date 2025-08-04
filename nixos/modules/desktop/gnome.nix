{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages =
    (with pkgs; [
      dconf-editor
      gnome-extension-manager
      gnome-tweaks
      resources
      showtime
    ])
    ++ (with pkgs.gnomeExtensions; [
      advanced-alttab-window-switcher
      always-show-workspace-thumbnails
      appindicator
      bing-wallpaper-changer
      blur-my-shell
      dash-to-panel
      focus-changer
      pano
      quick-settings-tweaker
      smile-complementary-extension
      space-bar
      tiling-assistant
    ]);

  environment.gnome.excludePackages = with pkgs; [
    gnome-system-monitor
    totem
  ];

  hm.gtk.enable = true;
  hm.home.pointerCursor = {
    package = pkgs.libsForQt5.breeze-qt5;
    name = "breeze_cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Unlock "login" GNOME keyring on login
  security.pam.services.login.enableGnomeKeyring = true;
}
