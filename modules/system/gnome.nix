{lib, ...}: {
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

        environment.systemPackages = let
          # Disable dragging maximized windows from empty dash-to-panel space
          dash-to-panel = pkgs.gnomeExtensions.dash-to-panel.overrideAttrs (oldAttrs: {
            postPatch =
              (oldAttrs.postPatch or "")
              + ''
                substituteInPlace panel.js --replace-fail \
                  "if (!dragWindow) return Clutter.EVENT_PROPAGATE" \
                  "return Clutter.EVENT_PROPAGATE"
              '';
          });
        in
          [dash-to-panel]
          ++ (with pkgs; [
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

    homeManager = {
      nixosConfig,
      pkgs,
      ...
    }: {
      gtk.enable = true;

      home.pointerCursor = {
        package = nixosConfig.pointerCursorPackage;
        name = "breeze_cursors";
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };

      custom-keybindings.console = {
        command = lib.getExe (with pkgs; gnome-console);
        binding = "<Super>Return";
      };
    };
  };
}
