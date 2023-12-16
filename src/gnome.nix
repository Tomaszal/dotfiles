{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages =
    [pkgs.gnome.gnome-tweaks]
    ++ (with pkgs.gnomeExtensions; [
      # always-show-workspace-thumbnails # no gnome 45 support
      # focus-changer # seems to be broken
      advanced-alttab-window-switcher
      appindicator
      bing-wallpaper-changer
      blur-my-shell
      dash-to-panel
      pano
      quick-settings-tweaker
      smile-complementary-extension
      space-bar
      tiling-assistant
    ]);

  hm.gtk.enable = true;
  hm.home.pointerCursor = {
    package = pkgs.libsForQt5.breeze-qt5;
    name = "breeze_cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Force correct theme for some GTK Flatpak apps
  # https://discourse.flathub.org/t/gtk4-apps-do-not-use-adwaita-dark/1327/2
  hm.services.flatpak.overrides."org.onlyoffice.desktopeditors".Environment.GTK_THEME = "Adwaita:dark";

  # Unlock "login" GNOME keyring on login
  security.pam.services.login.enableGnomeKeyring = true;
}
