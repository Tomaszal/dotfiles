{lib, ...}: {
  den.default = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.gnomeExtensions.smile-complementary-extension];
    };

    homeManager = {pkgs, ...}: {
      dconf.settings = {
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/smile/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/smile" = {
          name = "Emoji picker";
          command = lib.getExe (with pkgs; smile);
          binding = "<Super>period";
        };
      };
    };
  };
}
