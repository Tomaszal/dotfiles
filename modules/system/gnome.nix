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
            kooha
          ])
          ++ (with pkgs.gnomeExtensions; [
            advanced-alttab-window-switcher
            always-show-workspace-thumbnails
            focus-changer
            pano
            quick-settings-tweaker
          ]);

        environment.gnome.excludePackages = with pkgs; [
          gnome-system-monitor
          gnome-tour
          totem
        ];

        # Unlock "login" GNOME keyring on login
        security.pam.services.login.enableGnomeKeyring = true;
      };
    };

    homeManager = {
      nixosConfig,
      pkgs,
      ...
    }: {
      gtk.enable = true;

      programs.gnome-shell = {
        enable = true;
        extensions = with pkgs.gnomeExtensions; [
          {package = space-bar;}
          {package = bing-wallpaper-changer;}
          {package = appindicator;}
          {package = blur-my-shell;}
          {package = tiling-assistant;}
        ];
      };

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
