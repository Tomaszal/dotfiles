{
  den.default = {
    nixos = {
      pkgs,
      lib,
      ...
    }: {
      options.pointerCursorPackage = lib.mkOption {
        default = pkgs.kdePackages.breeze;
      };

      config = {
        services.displayManager.gdm.enable = true;
        services.desktopManager.gnome.enable = true;

        environment.sessionVariables.NIXOS_OZONE_WL = "1";

        environment.systemPackages =
          (with pkgs; [
            dconf-editor
            gnome-extension-manager
            gnome-tweaks
            mission-center
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
            space-bar
            tiling-assistant
          ]);

        environment.gnome.excludePackages = with pkgs; [
          gnome-system-monitor
          totem
        ];

        # Unlock "login" GNOME keyring on login
        security.pam.services.login.enableGnomeKeyring = true;
      };
    };

    homeManager = {nixosConfig, ...}: {
      gtk.enable = true;
      home.pointerCursor = {
        package = nixosConfig.pointerCursorPackage;
        name = "breeze_cursors";
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };
    };
  };
}
